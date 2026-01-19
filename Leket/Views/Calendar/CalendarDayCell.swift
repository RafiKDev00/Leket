//
//  CalendarDayCell.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

enum CalendarDayCellMode {
    case volunteer  //readonly, shows availability
    case farmer     //shows edit indicator, signup counts
}

struct CalendarDayCell: View {
    let date: Date
    let farmDay: FarmDay?
    let isSelected: Bool
    let isCurrentMonth: Bool
    let isSignedUp: Bool
    let mode: CalendarDayCellMode
    let onTap: () -> Void

    private var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }

    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    private var isPast: Bool {
        date < Calendar.current.startOfDay(for: Date())
    }

    private var isOpen: Bool {
        farmDay?.isOpen ?? false
    }

    private var spotsRemaining: Int {
        farmDay?.spotsRemaining ?? 0
    }

    private var signupCount: Int {
        farmDay?.signupCount ?? 0
    }

    private var volunteersNeeded: Int {
        farmDay?.volunteersNeeded ?? 0
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(dayNumber)")
                    .font(.system(size: 16, weight: isToday ? .bold : .regular))
                    .foregroundStyle(textColor)

                if isCurrentMonth && !isPast {
                    statusIndicator
                }
            }
            .frame(maxWidth: .infinity, minHeight: 44)
        }
        .glassEffect(in: Circle())
        .tint(backgroundColor)
     
        .overlay(
            Circle()
                .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
             )
        .disabled(!isCurrentMonth || isPast)
    }

    @ViewBuilder
    private var statusIndicator: some View {
        switch mode {
        case .volunteer:
            if isSignedUp {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(Color("Highland"))
            } else if isOpen && spotsRemaining > 0 {
                Circle()
                    .fill(Color("Highland").opacity(0.8))
                    .frame(width: 6, height: 6)
            } else if isOpen && spotsRemaining == 0 {
                Circle()
                    .fill(Color("RedDamask").opacity(0.6))
                    .frame(width: 6, height: 6)
            } else {
                Circle()
                    .fill(Color("BattleshipGray").opacity(0.3))
                    .frame(width: 6, height: 6)
            }

        case .farmer:
            if signupCount > 0 {
                Text("\(signupCount)")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(Color("RedDamask"))
                    .cornerRadius(4)
            } else if isOpen {
                Circle()
                    .fill(Color("Highland"))
                    .frame(width: 6, height: 6)
            } else {
                Circle()
                    .fill(Color("BattleshipGray").opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
    }

    private var textColor: Color {
        if !isCurrentMonth {
            return Color("BattleshipGray").opacity(0.3)
        }
        if isPast {
            return Color("BattleshipGray").opacity(0.5)
        }
        if isToday {
            return Color("RedDamask")
        }
        return Color("GrayAsparagus")
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color("Highland").opacity(0.15)
        }
        if isToday {
            return Color("RedDamask").opacity(0.1)
        }
        return .clear
    }

    private var borderColor: Color {
        if isSelected {
            return Color("Highland")
        }
        return .clear
    }
}

#Preview {
    HStack(spacing: 8) {
        CalendarDayCell(
            date: Date(),
            farmDay: FarmDay(
                id: "test_day",
                date: Date(),
                isOpen: true,
                volunteersNeeded: 5,
                tasks: ["Test"],
                signups: []
            ),
            isSelected: false,
            isCurrentMonth: true,
            isSignedUp: false,
            mode: .volunteer,
            onTap: {}
        )

        CalendarDayCell(
            date: Date(),
            farmDay: FarmDay(
                id: "test_day",
                date: Date(),
                isOpen: true,
                volunteersNeeded: 5,
                tasks: ["Test"],
                signups: []
            ),
            isSelected: true,
            isCurrentMonth: true,
            isSignedUp: true,
            mode: .volunteer,
            onTap: {}
        )
    }
    .padding()
}
