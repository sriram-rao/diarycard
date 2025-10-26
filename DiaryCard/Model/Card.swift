import Foundation
import SwiftData
import SwiftUI

@Model
final class Card: Hashable {
    var attributes: [String: Value]
    var date: Date
    var keys: [String] {
        var changed = false
        let migrated = self.attributes.reduce(into: [String: Value]()) { result, pair in
            let (k, v) = pair
            let newK = Schema.changes[k] ?? Schema.changes[k.lowercased()] ?? k
            if newK != k { changed = true }
            if result[newK] == nil { result[newK] = v }
        }
        if changed { self.attributes = migrated }
        return Array(self.attributes.keys)
    }

    init(date: Date = Date.today, attributes: [String: Value] = [:]) {
        self.attributes = attributes
        self.date = date
    }

    func get(key: String) -> Value {
        return attributes[key.lowercased()] ?? .nothing
    }
    
    func getWithSchemaChange(key: String) -> Value {
        let keyLower = key.lowercased()

        if Schema.changes.keys.contains(keyLower) {
            return .nothing
        }

        if let value = attributes[keyLower] {
            return value
        }

        if Schema.changes.values.contains(keyLower) {
            if let oldKey = attributes.keys.first(where: {
                (Schema.changes[$0] ?? Schema.changes[$0.lowercased()]) == keyLower
            }) {
                if let value = attributes[oldKey] {
                    attributes.removeValue(forKey: oldKey)
                    attributes[keyLower] = value
                    return value
                }
            }
            return .nothing
        }

        return attributes[keyLower] ?? .nothing
    }

    subscript(key: String) -> Value {
        self.getWithSchemaChange(key: key)
    }
    
    func hasKey(_ key: String) -> Bool {
        let lower = key.lowercased()

        if Schema.changes.keys.contains(lower) {
            return false
        }

        if self.attributes.keys.contains(lower) {
            return true
        }

        if Schema.changes.values.contains(lower) {
            return self.attributes.keys.contains(where: {
                (Schema.changes[$0] ?? Schema.changes[$0.lowercased()]) == lower
            })
        }

        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.attributes.hashValue)
    }
}
