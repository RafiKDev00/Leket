//
//  VolunteerProfileView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct VolunteerProfileView: View {
    @Environment(AppSession.self) private var session
    @State private var isEditing: Bool = false

    var body: some View {
        NavigationStack {
            if let volunteer = session.currentVolunteer {
                List {
                    Section {
                        VolunteerProfileHeader(volunteer: volunteer)
                    }

                    Section("Contact Information") {
                        LabeledContent("Email", value: volunteer.email)
                        LabeledContent("Phone", value: volunteer.phone)
                    }

                    Section("My Signups") {
                        if session.myDaySignups.isEmpty {
                            Text("No active signups")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(session.myDaySignups, id: \.signup.id) { signupInfo in
                                VolunteerSignupRow(signupInfo: signupInfo)
                            }
                        }
                    }

                    Section {
                        Button {
                            isEditing = true
                        } label: {
                            Label("Edit Profile", systemImage: "pencil")
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color("Highland"))

                        Button(role: .destructive) {
                            session.logout()
                        } label: {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color("RedDamask"))
                    }
                }
                .navigationTitle("Profile")
                .sheet(isPresented: $isEditing) {
                    VolunteerEditView(volunteer: volunteer) { updated in
                        session.updateVolunteer(updated)
                        isEditing = false
                    }
                }
            }
        }
    }
}

#Preview {
    VolunteerProfileView()
        .environment(AppSession())
}
