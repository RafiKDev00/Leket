//
//  FarmListView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI
import MapKit

struct FarmListView: View {
    @Environment(AppSession.self) private var session
    let farms: [Farm]
    @State private var sheetFarm: Farm?

    private var signedUpFarms: [Farm] {
        farms.filter { session.hasAnySignup(for: $0) }
    }

    private var otherFarms: [Farm] {
        farms.filter { !session.hasAnySignup(for: $0) }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if !signedUpFarms.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Signed Up For")
                            .font(.headline)
                            .foregroundStyle(Color("Highland"))
                            .padding(.horizontal)

                        ForEach(signedUpFarms) { farm in
                            FarmListCard(farm: farm, isSignedUp: true)
                                .onTapGesture {
                                    sheetFarm = farm
                                }
                        }
                    }

                    if !otherFarms.isEmpty {
                        Divider()
                            .padding(.vertical, 8)
                    }
                }

                ForEach(otherFarms) { farm in
                    FarmListCard(farm: farm, isSignedUp: false)
                        .onTapGesture {
                            sheetFarm = farm
                        }
                }
            }
            .padding()
        }
        .sheet(item: $sheetFarm) { farm in
            FarmDetailSheet(farm: farm, onClose: {
                sheetFarm = nil
            })
        }
    }
}

#Preview {
    FarmListView(farms: Farm.sampleFarms)
        .environment(AppSession())
}
