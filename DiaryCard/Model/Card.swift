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
}
