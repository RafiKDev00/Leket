//
//  VolunteerCalendarSheet.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct VolunteerCalendarSheet: View {
    @Environment(AppSession.self) private var session
    @Environment(\.dismiss) private var dismiss
    let farm: Farm
    var onSignupSuccess: ((Date) -> Void)?

    @State private var selectedDate: Date?
    @State private var showSignUpConfirmation: Bool = false
    @State private var showUnsignConfirmation: Bool = false

    private var selectedFarmDay: FarmDay? {
        guard let date = selectedDate else { return nil }
        return session.getFarmDay(for: farm, on: date)
    }

    private var canSignUp: Bool {
        guard let day = selectedFarmDay else { return false }
        guard let date = selectedDate else { return false }
        return day.isOpen && day.spotsRemaining > 0 && !session.isSignedUp(for: farm, on: date)
    }

    private var isAlreadySignedUp: Bool {
        guard let date = selectedDate else { return false }
        return session.isSignedUp(for: farm, on: date)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Farm header
                    HStack {
                        Image(farm.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 0)

                        VStack(alignment: .leading) {
                            Text(farm.name)
                                .font(.headline)
                                .foregroundStyle(Color("Highland"))
                            Text(farm.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(24)

                    HStack(spacing: 16) {
                        legendItem(color: Color("Highland"), label: "Open")
                        legendItem(color: Color("RedDamask").opacity(0.6), label: "Full")
                        legendItem(color: Color("BattleshipGray").opacity(0.3), label: "Closed")
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(Color("Highland"))
                            Text("Signed Up")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)

                    // Calendar
                    FarmCalendarView(
                        farm: farm,
                        mode: .volunteer,
                        selectedDate: $selectedDate,
                        onDayTapped: { _ in }
                    )

                    // Selected day details
                    if let date = selectedDate, let day = selectedFarmDay {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(date, style: .date)
                                    .font(.headline)
                                    .foregroundStyle(Color("GrayAsparagus"))

                                Spacer()

                                if day.isOpen {
                                    Text("\(day.spotsRemaining) spots left")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(day.spotsRemaining > 0 ? Color("Highland").opacity(0.2) : Color("RedDamask").opacity(0.2))
                                        .foregroundStyle(day.spotsRemaining > 0 ? Color("Highland") : Color("RedDamask"))
                                        .cornerRadius(8)
                                } else {
                                    Text("Closed")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color("BattleshipGray").opacity(0.2))
                                        .foregroundStyle(Color("BattleshipGray"))
                                        .cornerRadius(8)
                                }
                            }

                            if !day.tasks.isEmpty {
                                Text("Tasks")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("GrayAsparagus"))

                                ForEach(day.tasks, id: \.self) { task in
                                    HStack(spacing: 8) {
                                        Image(systemName: "leaf.fill")
                                            .font(.caption)
                                            .foregroundStyle(Color("Highland"))
                                        Text(task)
                                            .font(.caption)
                                    }
                                }
                            }

                            // Sign up / Unsign button
                            if isAlreadySignedUp {
                                Button {
                                    showUnsignConfirmation = true
                                } label: {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                        Text("You're signed up - Tap to cancel")
                                    }
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                }
                                .buttonStyle(.glassProminent)
                                .tint(Color("Highland"))
                            } else if canSignUp {
                                Button {
                                    showSignUpConfirmation = true
                                } label: {
                                    HStack {
                                        Image(systemName: "hand.raised.fill")
                                        Text("Sign Up for This Day")
                                    }
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                }
                                .buttonStyle(.glassProminent)
                                .tint(Color("RedDamask"))
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    } else {
                        Text("Select a day to see details")
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
            .navigationTitle("Volunteer Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color("Highland"))
                }
            }
            .alert("Confirm Sign Up", isPresented: $showSignUpConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Up") {
                    if let date = selectedDate {
                        session.signUpForDay(farm: farm, date: date)
                        onSignupSuccess?(date)
                        dismiss()
                    }
                }
            } message: {
                if let date = selectedDate {
                    Text("Would you like to sign up to volunteer at \(farm.name) on \(date, style: .date)?")
                }
            }
            .alert("Cancel Sign Up", isPresented: $showUnsignConfirmation) {
                Button("Keep Sign Up", role: .cancel) { }
                Button("Cancel Sign Up", role: .destructive) {
                    if let date = selectedDate {
                        session.unsignFromDay(farm: farm, date: date)
                    }
                }
            } message: {
                if let date = selectedDate {
                    Text("Are you sure you want to cancel your signup for \(farm.name) on \(date, style: .date)?")
                }
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

#Preview {
    VolunteerCalendarSheet(farm: Farm.sampleFarms[0])
        .environment(AppSession())
}
