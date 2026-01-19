//
//  FarmerLoginView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI
import MapKit

struct FarmerLoginView: View {
    @Environment(FarmerSession.self) private var session

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color("Highland"))

                Text("Farmer Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Select your farmer account")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    ForEach(Farmer.sampleFarmers) { farmer in
                        Button {
                            session.login(as: farmer)
                        } label: {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.title2)

                                VStack(alignment: .leading) {
                                    Text(farmer.name)
                                        .font(.headline)
                                    Text(farmer.email)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color("RedDamask"))
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 60)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    FarmerLoginView()
        .environment(FarmerSession())
}
