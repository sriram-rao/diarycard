import os.log
import SwiftData
import Foundation
import SwiftUI


extension Int {
    static var week: Int { 7 * day }
    static var day: Int { 24 * hour }
    static var hour: Int { 3_600 }
}

extension Comparable {
    func between(_ lhs: Self, and rhs: Self) -> Bool {
        return self >= lhs && self < rhs
    }
}

func not(_ condition: Bool) -> Bool {
    !condition
}

extension String {
    static var nothing: String { "" }
    static var space: String { " " }
    static var forwardSlash: String { "/" }
    static var backSlash: String { "\\" }
    static var equals: String { "=" }
    static var quote: String { "\"" }
    static var newline: String { "\n" }
    static var dot: String { "." }
    static var comma: String { "," }
    static var colon: String { ":" }
    static var semicolon: String { ";" }
    
    func isBlank() -> Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Case insensitive string check
    func equals(_ other: String) -> Bool {
        self.lowercased() == other.lowercased()
    }
}

extension Optional {
    func orUse(_ defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }
}

extension Date {
    static var today: Date {
        Calendar.current.startOfDay(for: Date.now)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func addDuration(_ number: Int, _ blockSize: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: blockSize, value: number, to: self)!
    }
    
    func goForward(_ duration: Int) -> Date {
        return self.addDuration(duration, .second)
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
            return "\(self.getRelativeWeek())\(self.getDay())"
        }
        return DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
    
    func getRelativeWeek(to reference: Date = Calendar.current.startOfDay(for: Date())) -> String {
        let currentWeek = Calendar.current.component(.weekOfYear, from: reference)
        let dayWeek = Calendar.current.component(.weekOfYear, from: self)
        
        return [-1: "Next ", 0: .nothing, 1: "Last "][currentWeek - dayWeek].orUse(.nothing)
    }
    
    func getDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = .current
        return formatter.string(from: self)
    }
    
    func toString(as format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
