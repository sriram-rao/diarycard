import os.log
import Foundation
import SwiftUI

extension String {
    func isEmptyOrWhitespace() -> Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension String? {
    func isNilOrWhiteSpace() -> Bool {
        guard let self = self else {
            return true 
        }
        return self.isEmptyOrWhitespace()
    }
}

extension Logger {
    static let log = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.srao.diarycard", category: "App")
}

extension Date {
    func getRelativeDay() -> String {
        let day = Calendar.current.startOfDay(for: self)
        let today = Calendar.current.startOfDay(for: Date())
        let timeBetween = abs(today.timeIntervalSince(day))
        
        if timeBetween == 0 { return "Today" }
        if timeBetween < TimeInterval(2 * 86_400) {
            return today > day ? "Yesterday" : "Tomorrow"
        }
        if timeBetween < TimeInterval(7 * 86_400) {
            return "\(self.getRelativeWeek()) \(self.getDay())"
        }
        return DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
    
    func getRelativeWeek(to reference: Date = Calendar.current.startOfDay(for: Date())) -> String {
        let currentWeek = Calendar.current.component(.weekOfYear, from: reference)
        let dayWeek = Calendar.current.component(.weekOfYear, from: self)
        
        return [ -1: "Last", 0: "",
                  1: "Next"][currentWeek - dayWeek] ?? ""
    }
    
    func getDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.dateStyle = .medium
        formatter.locale = .current
        return formatter.string(from: self)
    }
}

extension View {
    func run_if(_ condition: Bool, then action: () -> some View) -> AnyView {
        condition ? AnyView(action()) : AnyView(EmptyView())
    }
    
    func getBinding(for keyPath: WritableKeyPath<DateInterval, Date>,
                    from interval: Binding<DateInterval>) -> Binding<Date> {
        return Binding<Date>(
            get: { interval.wrappedValue[keyPath: keyPath] },
            set: { interval.wrappedValue[keyPath: keyPath] = $0 }
        )
    }
    
    func blackAndWhite(theme: ColorScheme) -> some View {
        self.foregroundStyle((theme == ColorScheme.light ? Color.black : .white).opacity(0.75))
    }
    
    func onChange<V>(anyOf values: V..., perform action: @escaping () -> Void) -> some View where V : Equatable {
        for value in values {
            _ = self.onChange(of: value) { action() }
        }
        return self.onAppear { action() }
    }
    
    func blurIf(_ condition: Bool) -> some View {
        self.blur(radius: 3 * (condition ? 1 : 0))
    }
}


extension Text {
    func blackAndWhite(theme: ColorScheme) -> some View {
        self.foregroundStyle((theme == ColorScheme.light ? Color.black : .white).opacity(0.75))
    }
}
