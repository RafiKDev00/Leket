//
//  SignupToast.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct SignupToast: View {
    let date: Date?

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white)
                VStack(alignment: .leading) {
                    Text("Congrats on signing up!")
                        .font(.headline)
                        .foregroundStyle(.white)
                    if let date {
                        Text("See you on \(date, style: .date)")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color("Highland"))
            .cornerRadius(24)
            .padding()
        }
    }
}

#Preview {
    SignupToast(date: Date())
}
