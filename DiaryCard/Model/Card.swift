import Foundation
import SwiftUI
import SwiftData

@Model
class Card {
    var attributes: Dictionary<String, Value>
    var date: Date
    
    init(date: Date, attributes: Dictionary<String, Value> = [:]) {
        self.attributes = attributes
        self.date = date
        self.attributes["date"] = Value.wrap(date)
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

extension Dictionary where Key == String, Value == [String] {
   
}

@Model
class ListSchemas {
    @MainActor private static let lists: ListSchemas = ListSchemas(schemas: [
        "skills.distress tolerance": ["ACCEPTS", "IMPROVE", "TIPP", "STOP"]
    ])
    
    @Transient
    var schemasCache: [String: [String]] = [:]
    
    var schemasJson: String = ""
    var schemas: [String: [String]] {
        get {
            if !schemasCache.isEmpty {
                return schemasCache
            }
            schemasCache = (try? JSONDecoder().decode([String: [String]].self, from: Data(schemasJson.utf8))) ?? [:]
            return schemasCache
        }
        
        set {
            schemasCache = newValue
            schemasJson = try! JSONDecoder().decode(String.self, from: JSONEncoder().encode(newValue))
        }
    }

    init(schemas: [String : [String]] = [:]) {
        self.schemas = schemas
    }
    
    subscript(listName: String, schemas: [String: [String]] = [:]) -> [String] {
        get { self.schemas[listName.lowercased()] ?? [] }
        set { self.schemas[listName.lowercased()] = newValue }
    }
    
    func get(_ listName: String) -> [String] {
        schemas[listName.lowercased()] ?? []
    }
    
    func toString(listName: String) -> String {
        get(listName).joined(separator: ", ")
    }
    
    func contains(listName: String, value: String) -> Bool {
        get(listName).contains(value)
    }
}
