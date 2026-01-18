//
//  FarmListCard.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI
import MapKit

struct FarmListCard: View {
    let farm: Farm

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(farm.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 140)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(farm.name)
                    .font(.headline)
                    .foregroundStyle(Color("Highland"))

                Text(farm.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    Label("\(farm.volunteersNeeded) needed", systemImage: "person.2")
                    Spacer()
                    Label(farm.farmer.name, systemImage: "person.crop.circle")
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if !farm.tasks.isEmpty {
                    Text(farm.tasks.joined(separator: " • "))
                        .font(.caption2)
                        .foregroundStyle(Color("BattleshipGray"))
                }
            }
            .padding()
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    FarmListCard(farm: Farm.sampleFarms[0])
        .padding()
}
