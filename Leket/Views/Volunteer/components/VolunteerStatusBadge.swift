//
//  VolunteerStatusBadge.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct VolunteerStatusBadge: View {
    let status: SignupStatus

    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor(for: status).opacity(0.2))
            .foregroundStyle(statusColor(for: status))
            .cornerRadius(8)
    }

    private func statusColor(for status: SignupStatus) -> Color {
        switch status {
        case .upcoming: return Color("Highland")
        case .active: return Color("RedDamask")
        case .completed: return Color("BattleshipGray")
        }
    }
}

#Preview {
    VolunteerStatusBadge(status: .upcoming)
        .padding()
}
