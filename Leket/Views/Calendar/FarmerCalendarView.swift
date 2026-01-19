//
//  FarmerCalendarView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct FarmerCalendarView: View {
    @Environment(AppSession.self) private var session
    @Environment(\.dismiss) private var dismiss
    let farm: Farm
    @State private var selectedDate: Date?
    @State private var editingDay: (date: Date, day: FarmDay)?

    private var currentFarm: Farm {
        session.farms.first(where: { $0.id == farm.id }) ?? farm
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Farm Visibility")
                                .font(.headline)
                                .foregroundStyle(Color("GrayAsparagus"))
                            Text(currentFarm.isPublic ? "Visible to volunteers" : "Hidden from volunteers")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            session.toggleFarmVisibility(currentFarm)
                        } label: {
                            Image(systemName: currentFarm.isPublic ? "eye.fill" : "eye.slash.fill")
                                .font(.title2)
                        }
                        .glassEffect( in: Circle())
                        .padding()
                        .tint(currentFarm.isPublic ? Color("Highland") : Color("BattleshipGray"))
                     
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(24)

                    // Legend
                    HStack(spacing: 16) {
                        legendItem(color: Color("Highland"), label: "Open")
                        legendItem(color: Color("BattleshipGray").opacity(0.3), label: "Closed")
                        HStack(spacing: 4) {
                            Text("3")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1)
                                .background(Color("RedDamask"))
                                .cornerRadius(4)
                            Text("Signups")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)


                    FarmCalendarView(
                        farm: currentFarm,
                        mode: .farmer,
                        selectedDate: $selectedDate,
                        onDayTapped: { date in
                            let farmDay = session.getFarmDay(for: currentFarm, on: date)
                            editingDay = (date, farmDay)
                        }
                    )

                    if let date = selectedDate {
                        let day = session.getFarmDay(for: currentFarm, on: date)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(date, style: .date)
                                    .font(.headline)
                                    .foregroundStyle(Color("GrayAsparagus"))

                                Spacer()

                                Button {
                                    editingDay = (date, day)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                }
                                .buttonStyle(.glassProminent)
                                .tint(Color("Highland"))
                            }

                            HStack(spacing: 16) {
                                VStack(alignment: .leading) {
                                    Text("Status")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text(day.isOpen ? "Open" : "Closed")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(day.isOpen ? Color("Highland") : Color("BattleshipGray"))
                                }

                                VStack(alignment: .leading) {
                                    Text("Volunteers")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("\(day.signupCount) / \(day.volunteersNeeded)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }

                                VStack(alignment: .leading) {
                                    Text("Spots Left")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("\(day.spotsRemaining)")
                                    Text("\(day.spotsRemaining)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(day.spotsRemaining > 0 ? Color("Highland") : Color("RedDamask"))
                                }
                            }

                            if !day.signups.isEmpty {
                                Text("Volunteers")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("GrayAsparagus"))

                                ForEach(day.signups) { signup in
                                    HStack(spacing: 8) {
                                        Image(systemName: "person.crop.circle.fill")
                                            .foregroundStyle(Color("Highland"))
                                        Text(signup.volunteer.fullName)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    } else {
                        Text("Tap a day to view details and edit")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(24)
                    }
                }
                .padding()
            }
            .navigationTitle("\(currentFarm.name) Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color("Highland"))
                    }
                    .glassEffect(in: Circle())
                }
     
            }
            .sheet(item: Binding(
                get: { editingDay.map { EditingDayWrapper(date: $0.date, day: $0.day) } },
                set: { editingDay = $0.map { ($0.date, $0.day) } }
            )) { wrapper in
                FarmerDayEditSheet(
                    farm: currentFarm,
                    date: wrapper.date,
                    farmDay: wrapper.day
                )
            }
        }
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// Helper wrapper to make the tuple Identifiable for sheet
private struct EditingDayWrapper: Identifiable {
    let date: Date
    let day: FarmDay
    var id: String { day.id }
}

#Preview {
    FarmerCalendarView(farm: Farm.sampleFarms[0])
        .environment(AppSession())
}
