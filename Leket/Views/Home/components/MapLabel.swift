//
//  MapLabel.swift
//  Leket
//
//  Created by RJ  Kigner on 1/14/26.
//

import SwiftUI

struct MapLabel: View {
    let farm: Farm
    
    var body: some View {
        Text(farm.name)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()  
                    .fill(Color("Highland"))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            )
        
    }
}

#Preview {
    MapLabel(farm: Farm.sampleFarms[0])
}
