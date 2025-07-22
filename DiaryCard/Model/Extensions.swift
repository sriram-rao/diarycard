import os.log
import SwiftData
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

extension String {
    static var nothing: String { "" }
}

extension Optional {
    func orDefaultTo(_ defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }
}

extension Logger {
    static let log = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.srao.diarycard", category: "App")
}

extension Date {
    static var today: Date {
        Calendar.current.startOfDay(for: Date.now)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func addDays(_ days: Int) -> Date {
        return addDuration(days, .day)
    }
    
    func addDuration(_ number: Int, _ blockSize: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: blockSize, value: number, to: self)!
    }
    
    func goForward(_ duration: Int) -> Date {
        return Date().addDuration(duration, .second)
    }
    
    func goBack(_ duration: Int) -> Date {
        return goForward(-duration)
    }
    
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
        
        return [ -1: "Next", 0: .nothing,
                  1: "Last"][currentWeek - dayWeek].orDefaultTo(.nothing)
    }
    
    func getDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = .current
        return formatter.string(from: self)
    }
}

extension View {
    func checkIf(_ condition: Bool, then showView: () -> some View,
               otherwise showDefault: () -> some View = { EmptyView() }) -> AnyView {
        condition ? AnyView(showView()) : AnyView(showDefault())
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
    
    func onAppearOrChange<V>(anyOf values: V..., perform action: @escaping () -> Void) -> some View where V : Equatable {
        for value in values {
            _ = self.onChange(of: value) { action() }
        }
        return self.onAppear { action() }
    }
    
    func blurIf(_ condition: Bool) -> some View {
        self.blur(radius: 3 * (condition ? 1 : 0))
    }
    
    func fetch(start: Date, end: Date, context: ModelContext) -> [Card] {
        let fetcher = FetchDescriptor<Card>(
            predicate: #Predicate { $0.date >= start && $0.date <= end },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return (try? context.fetch(fetcher)).orDefaultTo([])
    }
}


extension Text {
    func blackAndWhite(theme: ColorScheme) -> some View {
        self.foregroundStyle((theme == ColorScheme.light ? Color.black : .white).opacity(0.75))
    }
}

extension Int {
    static var week: Int { 7 * day }
    static var day: Int { 24 * hour }
    static var hour: Int { 3_600 }
}


// Section: Globals
func not(_ condition: Bool) -> Bool {
    !condition
}

extension Comparable {
    func between(_ lhs: Self, and rhs: Self) -> Bool {
        return self >= lhs && self <= rhs
    }
}

extension Equatable {
    func checkIf(_ condition: Bool, then trueValue: Self, otherwise falseValue: Self) -> Self {
        return condition ? trueValue : falseValue
    }
}
