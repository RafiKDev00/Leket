//
//  MapPin.swift
//  Leket
//
//  Created by RJ  Kigner on 1/14/26.
//

import SwiftUI

struct MapPin: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "leaf.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 12) // can use any shape ... maybe we want circle
                        .fill(Color("Highland"))
                        .shadow(radius: 3)
                )

            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundStyle(Color("Highland"))
                .offset(y: -5) //ugly way to do it
        }
    }
}

#Preview{
    MapPin()
}
