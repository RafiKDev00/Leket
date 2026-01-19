//
//  FarmerDashboardView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI
import MapKit

struct FarmerDashboardView: View {
    @Environment(AppSession.self) private var session
    @State private var editingFarm: Farm?
    @State private var calendarFarm: Farm?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    if let farmer = session.currentFarmer {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(Color("RedDamask"))

                            VStack(alignment: .leading) {
                                Text("Welcome back,")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(farmer.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }

                            Spacer()

                            Button("Logout") {
                                session.logout()
                            }
                            .buttonStyle(.glassProminent)
                            .tint(Color("RedDamask"))
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(24)
                    }


                    Text("My Farms")
                        .font(.headline)
                        .foregroundStyle(Color("GrayAsparagus"))

                    if session.myFarms.isEmpty {
                        Text("You don't have any farms yet.")
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        ForEach(session.myFarms) { farm in
                            FarmerFarmCard(
                                farm: farm,
                                onEdit: {
                                    editingFarm = farm
                                },
                                onCalendar: {
                                    calendarFarm = farm
                                },
                                onToggleVisibility: {
                                    session.toggleFarmVisibility(farm)
                                }
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Farmer Dashboard")
            .sheet(item: $editingFarm) { farm in
                FarmEditView(farm: farm) { updatedFarm in
                    session.updateFarm(updatedFarm)
                    editingFarm = nil
                }
            }
            .sheet(item: $calendarFarm) { farm in
                FarmerCalendarView(farm: farm)
            }
        }
    }
}

struct FarmerFarmCard: View {
    let farm: Farm
    let onEdit: () -> Void
    let onCalendar: () -> Void
    let onToggleVisibility: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(farm.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()

                Button {
                    onToggleVisibility()
                } label: {
                    Image(systemName: farm.isPublic ? "eye.fill" : "eye.slash.fill")
                        .font(.system(size: 14))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.glassProminent)
                .tint(farm.isPublic ? Color("Highland") : Color("BattleshipGray"))
                .padding(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(farm.name)
                        .font(.headline)
                        .foregroundStyle(Color("Highland"))

                    if !farm.isPublic {
                        Text("Hidden")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color("BattleshipGray").opacity(0.2))
                            .foregroundStyle(Color("BattleshipGray"))
                            .cornerRadius(4)
                    }

                    Spacer()

                    HStack(spacing: 8) {
                        Button {
                            onCalendar()
                        } label: {
                            Label("", systemImage: "calendar")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color("RedDamask"))

                        Button {
                            onEdit()
                        } label: {
                            Label("", systemImage: "pencil")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color("Highland"))
                    }
                }

                Text(farm.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack {
                    Label("\(farm.volunteersNeeded) needed", systemImage: "person.2")
                    Spacer()
                    Label("\(farm.totalDaySignups) signed up", systemImage: "checkmark.circle")
                }
                .font(.caption2)
                .foregroundStyle(Color("BattleshipGray"))
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    FarmerDashboardView()
        .environment(AppSession())
}
