//
//  VolunteerEditView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct VolunteerEditView: View {
    let volunteer: Volunteer
    let onSave: (Volunteer) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phone: String

    init(volunteer: Volunteer, onSave: @escaping (Volunteer) -> Void) {
        self.volunteer = volunteer
        self.onSave = onSave
        _firstName = State(initialValue: volunteer.firstName)
        _lastName = State(initialValue: volunteer.lastName)
        _email = State(initialValue: volunteer.email)
        _phone = State(initialValue: volunteer.phone)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("First Name", text: $firstName)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                       
                    TextField("Last Name", text: $lastName)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }

                Section("Contact") {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)


                    TextField("Phone", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color("BattleshipGray"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = Volunteer(
                            id: volunteer.id,
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            phone: phone
                        )
                        onSave(updated)
                    }
                    .fontWeight(.semibold)
                    .buttonStyle(.glassProminent)
                    .tint(Color("Highland"))
                }
            }
        }
    }
}

#Preview {
    VolunteerEditView(volunteer: Volunteer.sampleVolunteers[0]) { _ in }
}
