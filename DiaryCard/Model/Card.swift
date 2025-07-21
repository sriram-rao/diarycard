import Foundation
import SwiftUI
import SwiftData

@Model
final class Card {
    var attributes: Dictionary<String, Value>
    var date: Date
    var keys: [String] {
        Array(self.attributes.keys)
    }
    var id: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    init(date: Date, attributes: Dictionary<String, Value> = [:]) {
        self.attributes = attributes
        self.date = date
    }
    
    func get(key: String) -> Value {
        return attributes[key.lowercased()] ?? Value.wrap("")!
    }
    
    subscript(key: String) -> Value {
        self.get(key: key)
    }
    
    func getAttributeNames() -> [String] {
        Array(attributes.keys)
    }
}

extension Card {
    func getBinding(key: String) -> Binding<Value> {
        guard attributes[key] != nil else {
            return Binding(get: {Value.wrap("")!}, set: {_ in})
        }
        
        return Binding(
            get: { self.attributes[key]! },
            set: { newValue in self.attributes[key] = newValue }
        )
    }
}

extension String {
    /// Has order/position part removed... group.1.field --> group.field.
    var key: String { self.getKeyName() }
    
    /// The order rank corresponding to an (unpassed) list)
    /// i.e. the number in the string, if present as the second of the dot-separated strings.
    /// If self has no number, value is 1000.
    /// group.1.field:sub --> 1
    var position: Int { self.getPosition() }
    
    /// The name of the field without prefixes and sub-fields... group.1.field:sub --> field
    var field: String { self.getFieldName() }
    
    /// The name of the field without sub-field suffixes. Like self.field, but retains prefix...
    /// group.1.field:sub --> group.1.field
    var fieldFull: String { self.getFullFieldName() }
    
    /// The first word in a dot-separated list of words... group.1.field --> group
    func getGroup() -> String {
        return self.components(separatedBy: ".").first ?? ""
    }
    
    /// The number part in a dot-separated list of strings, if present as the second of the dot-separated strings. Otherwise 1000...
    /// group.1.field --> 1; group.field --> 1000
    func getPosition() -> Int {
        return Int(self.components(separatedBy: ".")[1]) ?? 1000
    }
    
    /// The full string except the number part... group.1.field --> group.field
    func getKeyName() -> String {
        return self.replacingOccurrences(of: "\(self.getPosition()).", with: "")
    }
    
    /// The name of the attribute, including sub-field if self is a sub-field... group.1.field:sub --> field:sub
    func getName() -> String {
        return self.components(separatedBy: ".").last ?? ""
    }
    
    /// Is self a sub-field? (Checks for presence of ":")... group.1.field:sub --> true; group.1.field --> false
    func isSubType() -> Bool {
        return self.contains(":")
    }
    
    /// The name of the field without prefixes and sub-fields. group.1.field:sub --> field
    func getFieldName() -> String {
        return self.isSubType()
            ? self.getName().components(separatedBy: ":").first!
            : self.getName()
    }
    
    /// The name of the field without sub-field suffixes.
    /// Like self.getFieldName, but retains prefix...
    /// group.1.field:sub --> group.1.field
    func getFullFieldName() -> String {
        return self.isSubType()
            ? self.components(separatedBy: ":").first!
            : self
    }
    
    /// The name of the sub-field only... group.1.field:sub --> sub
    func getSubfieldName() -> String {
        return self.isSubType()
            ? self.getName().components(separatedBy: ":").last!
            : ""
    }

    /// Finds all sub-fields of self using the array (keys).
    func getSubfields(keys: [String]) -> [String] {
        keys.filter({
            $0.isSubType() && $0.getFullFieldName() == self
        })
    }
    
    /// The parent key by dropping the last word in a dop-separated (ordered) list... 
    /// group.1.field:sub --> group.1
    func getParentKey() -> String {
        return self.split(separator: ".").dropLast().joined(separator: ".")
    }
}

class DateRange: ObservableObject {
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
}
