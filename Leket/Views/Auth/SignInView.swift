//
//  SignInView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

enum SignInMethod {
    case email
    case phone
}

struct SignInView: View {
    let userType: UserType
    @Environment(AppSession.self) private var session
    @Environment(\.dismiss) private var dismiss

    @State private var signInMethod: SignInMethod = .email
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var showError: Bool = false
    @State private var navigateToOnboarding: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: userType == .volunteer ? "person.fill" : "leaf.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(userType == .volunteer ? Color("Highland") : Color("RedDamask"))

                Text(userType == .volunteer ? "Volunteer Sign In" : "Farmer Sign In")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.top, 20)

            Picker("Sign in with", selection: $signInMethod) {
                Text("Email").tag(SignInMethod.email)
                Text("Phone").tag(SignInMethod.phone)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                if signInMethod == .email {
                    Text("Email Address")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("Enter your email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 22)
                        .background(
                            Capsule()
                                .fill(Color(.secondarySystemBackground))
                        )
                        
                } else {
                    Text("Phone Number")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("Enter your phone", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 22)
                        .background(
                            Capsule()
                                .fill(Color(.secondarySystemBackground))
                        )
                }

                if showError {
                    Text("Account not found. Please sign up.")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)

            Button {
                attemptSignIn()
            } label: {
                Text("Sign In")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .padding(.horizontal)
            .buttonStyle(.glassProminent)
            .tint(userType == .volunteer ? Color("Highland") : Color("RedDamask"))

            HStack {
                Rectangle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(height: 1)
                Text("or")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Rectangle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal)

            Button {
                session.startOnboarding(as: userType)
            } label: {
                Text("Create New Account")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(userType == .volunteer ? Color("Highland") : Color("RedDamask"))
            }
            .padding(.horizontal)
            .buttonStyle(.glassProminent)
            .tint(Color(.secondarySystemBackground))
                  

            Spacer()

            VStack(spacing: 4) {
                Text("Sample accounts for testing:")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                if userType == .volunteer {
                    Text("daniel@example.com, sara@example.com")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                } else {
                    Text("yael@galilee-grove.il, avi@negev-fields.il")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func attemptSignIn() {
        showError = false
        let success: Bool

        if signInMethod == .email {
            success = session.signIn(email: email, as: userType)
        } else {
            success = session.signIn(phone: phone, as: userType)
        }

        if !success {
            showError = true
        }
    }
}

#Preview("Volunteer") {
    NavigationStack {
        SignInView(userType: .volunteer)
    }
    .environment(AppSession())
}

#Preview("Farmer") {
    NavigationStack {
        SignInView(userType: .farmer)
    }
    .environment(AppSession())
}
