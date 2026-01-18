//
//  FarmListView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI
import MapKit

struct FarmListView: View {
    let farms: [Farm]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(farms) { farm in
                    FarmListCard(farm: farm)
                }
            }
            .padding()
        }
    }
}

#Preview {
    FarmListView(farms: Farm.sampleFarms)
}
