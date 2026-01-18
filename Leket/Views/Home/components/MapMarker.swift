//
//  MapMarker.swift
//  Leket
//
//  Created by RJ  Kigner on 1/14/26.
//

import SwiftUI
import MapKit

struct FarmMapMarker: View {
    let farm: Farm
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            if isSelected {
                FarmListCard(farm: farm)
                    .frame(width: 280)
                    .transition(AnyTransition.scale.combined(with: AnyTransition.opacity))
            } else {
                MapPin()
                MapLabel(farm: farm)
                    .fixedSize()
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isSelected)
    }
}

#Preview("Collapsed") {
    FarmMapMarker(farm: Farm.sampleFarms[0], isSelected: false)
}

#Preview("Expanded") {
    FarmMapMarker(farm: Farm.sampleFarms[0], isSelected: true)
}
