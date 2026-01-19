//
//  VolunteerSignupRow.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct VolunteerSignupRow: View {
    let signupInfo: (farm: Farm, date: Date, signup: VolunteerSignup)

    var body: some View {
        HStack(spacing: 12) {
            Image(signupInfo.farm.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 0)

            VStack(alignment: .leading, spacing: 4) {
                Text(signupInfo.farm.name)
                    .font(.headline)
                    .foregroundStyle(Color("Highland"))
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(signupInfo.date, style: .date)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }

            Spacer()

            VolunteerStatusBadge(status: signupInfo.signup.status)
        }
    }
}

#Preview {
    let signup = VolunteerSignup(
        id: "preview-signup",
        volunteer: Volunteer.sampleVolunteers[0],
        farmID: Farm.sampleFarms[0].id,
        range: DateRange(start: Date(), end: Date()),
        status: .upcoming
    )

    return VolunteerSignupRow(signupInfo: (farm: Farm.sampleFarms[0], date: Date(), signup: signup))
        .padding()
}
