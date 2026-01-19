//
//  FarmDetailSheet.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI
import MapKit

struct FarmDetailSheet: View {
    @Environment(AppSession.self) private var session
    let farm: Farm
    let onClose: () -> Void
    @State private var showCalendar: Bool = false
    @State private var showSignupToast: Bool = false
    @State private var signupDate: Date?

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Image(farm.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()

                    VStack(alignment: .leading, spacing: 16) {
                        Text(farm.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color("Highland"))

                        Text(farm.description)
                            .font(.body)
                            .foregroundStyle(.secondary)

                        Divider()

                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color("Highland"))
                            VStack(alignment: .leading) {
                                Text("Farmer")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(farm.farmer.name)
                                    .font(.headline)
                            }
                        }

                        HStack {
                            Image(systemName: "person.2.fill")
                                .font(.title2)
                                .foregroundStyle(Color("RedDamask"))
                            VStack(alignment: .leading) {
                                Text("Volunteers Needed")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(farm.volunteersNeeded) people")
                                    .font(.headline)
                            }
                        }

                        Divider()

                        Text("Tasks")
                            .font(.headline)
                            .foregroundStyle(Color("GrayAsparagus"))

                        ForEach(farm.tasks, id: \.self) { task in
                            HStack {
                                Image(systemName: "leaf.fill")
                                    .foregroundStyle(Color("Highland"))
                                Text(task)
                            }
                            .padding(.vertical, 4)
                        }

                        Spacer(minLength: 24)

                        if session.userType == .volunteer {
                            Button {
                                showCalendar = true
                            } label: {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("View Calendar & Sign Up")
                                }
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            .buttonStyle(.glassProminent)
                            .tint(Color("RedDamask"))
                        }

                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .ignoresSafeArea(edges: .top)
            .sheet(isPresented: $showCalendar) {
                VolunteerCalendarSheet(farm: farm) { date in
                    signupDate = date
                    showSignupToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        showSignupToast = false
                    }
                }
            }

            Button {
                onClose()
            } label: {
                CloseButton(action: onClose)
            }
            .padding(.leading, 16)
            .padding(.top, 16)

            if showSignupToast {
                SignupToast(date: signupDate)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(), value: showSignupToast)
            }
        }
    }
}

#Preview {
    FarmDetailSheet(farm: Farm.sampleFarms[0], onClose: {})
        .environment(AppSession())
}
