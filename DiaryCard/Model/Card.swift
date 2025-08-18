import Foundation
import SwiftData
import SwiftUI

@Model
final class Card: Hashable {
    var attributes: [String: Value]
    var date: Date
    var keys: [String] {
        Array(self.attributes.keys)
    }

    init(date: Date, attributes: [String: Value] = [:]) {
        self.attributes = attributes
        self.date = date
    }

    func get(key: String) -> Value {
        return attributes[key.lowercased()] ?? .nothing
    }

    subscript(key: String) -> Value {
        self.get(key: key)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.attributes.hashValue)
    }
}
