//
//  VolunteerProfileHeader.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct VolunteerProfileHeader: View {
    let volunteer: Volunteer

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color("Highland"))
                .shadow(color: Color("Highland").opacity(0.2), radius: 10)

            VStack(alignment: .leading, spacing: 4) {
                Text(volunteer.fullName)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Volunteer")
                    .font(.subheadline)
                    .foregroundStyle(Color("Highland"))
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    VolunteerProfileHeader(volunteer: Volunteer.sampleVolunteers[0])
        .padding()
}
