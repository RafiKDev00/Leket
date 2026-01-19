//
//  FarmerDayEditSheet.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct FarmerDayEditSheet: View {
    @Environment(AppSession.self) private var session
    @Environment(\.dismiss) private var dismiss
    let farm: Farm
    let date: Date
    @State private var isOpen: Bool
    @State private var volunteersNeeded: Int
    @State private var tasksText: String
    @State private var originalDay: FarmDay
    @State private var selectedVolunteer: Volunteer?

    init(farm: Farm, date: Date, farmDay: FarmDay) {
        self.farm = farm
        self.date = date
        self._isOpen = State(initialValue: farmDay.isOpen)
        self._volunteersNeeded = State(initialValue: farmDay.volunteersNeeded)
        self._tasksText = State(initialValue: farmDay.tasks.joined(separator: "\n"))
        self._originalDay = State(initialValue: farmDay)
    }

    private var signups: [VolunteerSignup] {
        originalDay.signups
    }

    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(Color("Highland"))
                            Text(date, style: .date)
                                .font(.headline)
                        }
                    } header: {
                        Text("Date")
                    }

                    Section {
                        Toggle("Day is Open", isOn: $isOpen)
                            .tint(Color("Highland"))

                        Stepper(value: $volunteersNeeded, in: 1...50) {
                            HStack {
                                Text("Volunteers Needed")
                                Spacer()
                                Text("\(volunteersNeeded)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } header: {
                        Text("Availability")
                    }

                    Section {
                        TextEditor(text: $tasksText)
                            .frame(minHeight: 100)
                            .cornerRadius(24)
                    } header: {
                        Text("Tasks (one per line)")
                    } footer: {
                        Text("Enter each task on a separate line")
                    }

                    if !signups.isEmpty {
                        Section {
                            ForEach(signups) { signup in
                                Button {
                                    selectedVolunteer = signup.volunteer
                                } label: {
                                    HStack {
                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.title2)
                                            .foregroundStyle(Color("Highland"))
                                        VStack(alignment: .leading) {
                                            Text(signup.volunteer.fullName)
                                                .font(.subheadline)
                                                .foregroundStyle(.primary)
                                            Text(signup.volunteer.email)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .tint(Color("GrayAsparagus"))
                            }
                        } header: {
                            Text("Signed Up Volunteers (\(signups.count))")
                        } footer: {
                            Text("Tap a volunteer to see their contact info")
                        }
                    }
                }
                .navigationTitle("Edit Day")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color("BattleshipGray"))
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            saveChanges()
                            dismiss()
                        }
                        .fontWeight(.semibold)
                        .buttonStyle(.glassProminent)
                        .tint(Color("Highland"))
                    }
                }
            }

            // Volunteer detail popup overlay
            if let volunteer = selectedVolunteer {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedVolunteer = nil
                    }

                VolunteerDetailPopup(volunteer: volunteer) {
                    selectedVolunteer = nil
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: selectedVolunteer != nil)
    }

    private func saveChanges() {
        let tasks = tasksText
            .split(separator: "\n")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let updatedDay = FarmDay(
            id: originalDay.id,
            date: date,
            isOpen: isOpen,
            volunteersNeeded: volunteersNeeded,
            tasks: tasks,
            signups: originalDay.signups
        )

        session.updateFarmDay(updatedDay, for: farm)
    }
}

#Preview {
    let sampleDay = FarmDay(
        id: "test_day",
        date: Date(),
        isOpen: true,
        volunteersNeeded: 5,
        tasks: ["Harvest citrus", "Prune olives"],
        signups: [
            VolunteerSignup(
                id: "signup-preview",
                volunteer: Volunteer.sampleVolunteers[0],
                farmID: "farm-galilee",
                range: DateRange(start: Date(), end: Date()),
                status: .upcoming
            )
        ]
    )

    FarmerDayEditSheet(
        farm: Farm.sampleFarms[0],
        date: Date(),
        farmDay: sampleDay
    )
    .environment(AppSession())
}
