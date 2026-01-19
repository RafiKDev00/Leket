//
//  FarmerOnboardingView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct FarmerOnboardingView: View {
    @Environment(AppSession.self) private var session
    @State private var currentStep: Int = 0


    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                ForEach(0..<3) { step in
                    Capsule()
                        .fill(step <= currentStep ? Color("RedDamask") : Color.secondary.opacity(0.3))
                        .frame(height: 4)
                }
            }
            .padding()

            TabView(selection: $currentStep) {

                FarmerOnboardingStepView(
                    icon: "person.fill",
                    title: "What's your name?",
                    subtitle: "Volunteers will see this on your farm listings"
                ) {
                    TextField("Full Name", text: $name)
                        .textContentType(.name)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 22)
                        .background(
                            Capsule()
                                .fill(Color(.secondarySystemBackground))
                        )
                }
                .tag(0)

                FarmerOnboardingStepView(
                    icon: "envelope.fill",
                    title: "Your email address",
                    subtitle: "For account recovery and volunteer inquiries"
                ) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 22)
                        .background(
                            Capsule()
                                .fill(Color(.secondarySystemBackground))
                        )
                }
                .tag(1)

                FarmerOnboardingStepView(
                    icon: "phone.fill",
                    title: "Your phone number",
                    subtitle: "Volunteers may need to contact you"
                ) {
                    TextField("Phone Number", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 22)
                        .background(
                            Capsule()
                                .fill(Color(.secondarySystemBackground))
                        )
                }
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack {
                if currentStep > 0 {
                    Button {
                        withAnimation {
                            currentStep -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                            .frame(width: 48, height: 48)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(canProceed ? Color("RedDamask") : Color.secondary)
                }

                Spacer()

                Button {
                    if currentStep < 2 {
                        withAnimation {
                            currentStep += 1
                        }
                    } else {
                        completeOnboarding()
                    }
                } label: {
                    Image(systemName: currentStep < 2 ? "chevron.right" : "checkmark")
                        .fontWeight(.semibold)
                        .frame(width: 48, height: 48)
                }
                .disabled(!canProceed)
                .buttonStyle(.glassProminent)
                .tint(canProceed ? Color("RedDamask") : Color.secondary)
            }
            .padding()
        }
    }

    private var canProceed: Bool {
        switch currentStep {
        case 0: return !name.isEmpty
        case 1: return !email.isEmpty && email.contains("@")
        case 2: return !phone.isEmpty
        default: return false
        }
    }

    private func completeOnboarding() {
        session.completeFarmerOnboarding(
            name: name,
            email: email,
            phone: phone
        )
    }
}

struct FarmerOnboardingStepView<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(Color("RedDamask"))

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            content
                .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 40)
    }
}

#Preview {
    FarmerOnboardingView()
        .environment(AppSession())
}
