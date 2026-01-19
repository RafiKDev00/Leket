//
//  closeButton.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .foregroundColor(Color("GrayAsparagus"))
//                .font(.system(size: 20, weight: .bold))
                .frame(width: 36, height: 36)
        }
        .buttonStyle(.plain)
        .glassEffect( in: Circle())
    }
}

#Preview {
    CloseButton(action: {})
}
