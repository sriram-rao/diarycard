import Foundation
import HorizonCalendar
import SwiftUI

struct CalendarView: View {
    
    var body: some View {
        calendarBase
            .edgesIgnoringSafeArea(.all)
    }
    
    var calendarBase: some View {
        let calendar = Calendar.current
        let now = Date()
        let startDate = Calendar.current.date(byAdding: DateComponents(year: -1), to: now)!
        let endDate = Calendar.current.date(byAdding: DateComponents(year: 1), to: now)!
        
        return CalendarViewRepresentable(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
            dataDependency: nil)
        .days({day in
            Text("\(day.day)")
                .font(.system(size: 16))
                .foregroundStyle(.navy)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue, lineWidth: 1)
                }
        })
        .interMonthSpacing(24)
        .verticalDayMargin(16)
        .horizontalDayMargin(8)
        .layoutMargins(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}
