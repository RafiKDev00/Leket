//
//  VolunteerDetailPopup.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct VolunteerDetailPopup: View {
    let volunteer: Volunteer
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                CloseButton(action: onClose)
            }
            .padding(.horizontal)
            .padding(.top, 12)

            VStack(spacing: 16) {

                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color("Highland"))
                    .shadow(color: Color("Highland"), radius: 2, x: 0, y: 0)

                Text(volunteer.fullName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("GrayAsparagus"))

                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .font(.title3)
                            .foregroundStyle(Color("Highland"))
                            .frame(width: 30)

                        VStack(alignment: .leading) {
                            Text("Email")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(volunteer.email)
                                .font(.subheadline)
                        }

                        Spacer()

                        if let url = URL(string: "mailto:\(volunteer.email)") {
                            Link(destination: url) {
                                Image(systemName: "arrow.up.right.square")
                                    .foregroundStyle(Color("Highland"))
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(24)

                    // Phone
                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill")
                            .font(.title3)
                            .foregroundStyle(Color("RedDamask"))
                            .frame(width: 30)

                        VStack(alignment: .leading) {
                            Text("Phone")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(volunteer.phone)
                                .font(.subheadline)
                        }

                        Spacer()

                        if let url = URL(string: "tel:\(volunteer.phone)") {
                            Link(destination: url) {
                                Image(systemName: "phone.arrow.up.right")
                                    .foregroundStyle(Color("RedDamask"))
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(24)
                }
            }
            .padding()
        }
        .background(.background)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        VolunteerDetailPopup(
            volunteer: Volunteer.sampleVolunteers[0],
            onClose: {}
        )
    }
}
