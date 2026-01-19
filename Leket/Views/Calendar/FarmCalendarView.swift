//
//  FarmCalendarView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct FarmCalendarView: View {
    @Environment(AppSession.self) private var session
    let farm: Farm
    let mode: CalendarDayCellMode
    @Binding var selectedDate: Date?
    let onDayTapped: (Date) -> Void

    @State private var currentMonth: Date = Date()

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }

    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else { return [] }

        let startDate = monthFirstWeek.start
        let endDate = monthLastWeek.end

        var dates: [Date] = []
        var date = startDate
        while date < endDate {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }

    var body: some View {
        VStack(spacing: 16) {
            // Month navigation
            HStack {
                Button {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    
                }
                .padding()
                .glassEffect(in: Circle())
                .tint(Color("Highland"))

                Spacer()

                Text(monthYearString)
                    .font(.headline)
                    .foregroundStyle(Color("GrayAsparagus"))

                Spacer()

                Button {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .padding()
                .glassEffect(in: Circle())
                .tint(Color("Highland"))
            }
            .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color("BattleshipGray"))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 4)

            // Calendar grid
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(daysInMonth, id: \.self) { date in
                    let isCurrentMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    let farmDay = isCurrentMonth ? session.getFarmDay(for: farm, on: date) : nil
                    let isSignedUp = session.isSignedUp(for: farm, on: date)

                    CalendarDayCell(
                        date: date,
                        farmDay: farmDay,
                        isSelected: selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false,
                        isCurrentMonth: isCurrentMonth,
                        isSignedUp: isSignedUp,
                        mode: mode,
                        onTap: {
                            selectedDate = date
                            onDayTapped(date)
                        }
                    )
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

#Preview {
    @Previewable @State var selectedDate: Date? = nil

    FarmCalendarView(
        farm: Farm.sampleFarms[0],
        mode: .volunteer,
        selectedDate: $selectedDate,
        onDayTapped: { _ in }
    )
    .environment(AppSession())
    .padding()
}
