import SwiftUI

extension View {
    func run_if(_ condition: Bool, then action: () -> some View) -> AnyView {
        condition ? AnyView(action()) : AnyView(EmptyView())
    }
    
    func getRelativeDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let calendar = Calendar.current

        let day = calendar.startOfDay(for: date)
        let today = calendar.startOfDay(for: Date())
        let timeBetween = abs(today.timeIntervalSince(day))
        
        if timeBetween >= TimeInterval(7 * 86_400) {
            return DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
        }
        if timeBetween == TimeInterval(0) {
            return "Today"
        }
        if timeBetween < TimeInterval(2 * 86_400) {
            return today > day ? "Yesterday" : "Tomorrow"
        }
        formatter.locale = .current
        formatter.dateFormat = "EEEE"
        return "\(day < today ? "Last" : "") \(formatter.string(from: date))"
    }
}
