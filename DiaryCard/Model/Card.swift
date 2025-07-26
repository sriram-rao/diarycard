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
        return attributes[key.lowercased()] ?? .nothing
    }
    
    subscript(key: String) -> Value {
        self.get(key: key)
    }
    
    func getAttributeNames() -> [String] {
        Array(attributes.keys)
    }
}
