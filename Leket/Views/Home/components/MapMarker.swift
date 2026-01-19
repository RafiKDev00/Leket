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
    var onClose: (() -> Void)? = nil
    var onCardTap: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .center) {
            //collapsed: pin + label (fades out when selected)
            VStack(spacing: 4) {
                MapPin()
                MapLabel(farm: farm)
                    .fixedSize()
            }
            .opacity(isSelected ? 0 : 1)
            .scaleEffect(isSelected ? 0.5 : 1)

            // Expanded: card with close button (scales up from center)
            if isSelected {
                ZStack(alignment: .topTrailing) {
                    FarmListCard(farm: farm)
                        .frame(width: 280)

                    Button {
                        onClose?()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("GrayAsparagus"))
                            .frame(width: 36, height: 36)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(8)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onCardTap?()
                }
                .transition(.scale(scale: 0.1, anchor: .center).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
    }
}

#Preview("Collapsed") {
    FarmMapMarker(farm: Farm.sampleFarms[0], isSelected: false)
}

#Preview("Expanded") {
    FarmMapMarker(farm: Farm.sampleFarms[0], isSelected: true)
}
