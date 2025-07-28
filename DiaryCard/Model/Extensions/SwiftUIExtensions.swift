import SwiftUI

extension Card {
    func getBinding(key: String) -> Binding<Value> {
        guard attributes[key] != nil else {
            return Binding(get: {Value.wrap(String.nothing)!}, set: {_ in})
        }
        
        return Binding(
            get: { self.attributes[key]! },
            set: { newValue in self.attributes[key] = newValue }
        )
    }
}

extension String {
    /// Has order/position part removed... group.1.field --> group.field.
    var key: String {
        self.replacingOccurrences(of: [self.position.description, String.dot].merged, with: String.nothing)
    }
    
    /// The order rank corresponding to an (unpassed) list)
    /// i.e. the number in the string, if present as the second of the dot-separated strings.
    /// If self has no number, returns 1000.
    /// group.1.field:sub --> 1
    var position: Int {
        Int(self.components(separatedBy: String.dot)
            .second).orDefaultTo(1000)
    }
    
    /// The name of the field without prefixes and sub-fields...
    ///  group.1.field:sub --> field
    var field: String {
        self.isSubfield
            ? self.fieldFull.name
            : self.name
    }
    
    /// The name of the field without sub-field suffixes.
    /// Like self.field, but retains prefix...
    /// group.1.field:sub --> group.1.field
    var fieldFull: String {
        self.isSubfield
        ? self.components(separatedBy: String.colon).first!
            : self
    }
    
    /// The first word in a dot-separated list of words... group.1.field --> group
    var group: String {
        self.components(separatedBy: String.dot)
            .first.orDefaultTo(.nothing)
    }
    
    /// The name of the attribute, including sub-field if self is a sub-field... group.1.field:sub --> field:sub
    var name: String {
        self.components(separatedBy: String.dot)
            .last.orDefaultTo(.nothing)
    }
    
    /// The name of the sub-field only... group.1.field:sub --> sub
    var subfield: String {
        return self.isSubfield
            ? self.components(separatedBy: String.colon).last!
            : .nothing
    }
    
    /// Is self a sub-field? (Checks for presence of ":")...
    /// group.1.field:sub --> true; group.1.field --> false
    var isSubfield: Bool {
        self.contains(.colon)
    }

    /// Finds all sub-fields of self using the array (keys).
    func getSubfields(keys: [String]) -> [String] {
        keys.filter({
            $0.isSubfield && self.equals($0.fieldFull)
        })
    }
    
    /// Checks if self is a part of the group, i.e., self begins with group + .dot
    func belongsTo(_ group: String) -> Bool {
        return self.group.equals(group)
    }
    
    func checkStandalone(in names: [String]) -> Bool {
        not(isSubfield && names.contains(where: {
            $0.key.equals(self.key.fieldFull) && $0 != self
        }))
    }
}

extension Array where Element == String {
    func ofGroup(_ group: String) -> Array<String> {
        self.filter( {$0.belongsTo(group) })
    }
    
    func getFieldNames() -> Array<String> {
        Array(Set(self.map(\.field.capitalized)))
    }
    
    var fields: Array<String> {
        self.getFieldNames()
    }
    
    var second: String {
        self[1]
    }
}

extension Binding where Value == diarycard.Value {
    func toString() -> String {
        return wrappedValue.toString()
    }
}
