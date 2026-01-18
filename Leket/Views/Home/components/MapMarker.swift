//
//  MapMarker.swift
//  Leket
//
//  Created by RJ  Kigner on 1/14/26.
//

import SwiftUI

struct FarmMapMarker: View {
    let farm: Farm

    var body: some View {
        VStack(spacing: 4) {
            MapPin()
            MapLabel(farm: farm)
                .fixedSize()
        }
    }
}

#Preview{
    FarmMapMarker(farm: Farm.sampleFarms[0])
}
