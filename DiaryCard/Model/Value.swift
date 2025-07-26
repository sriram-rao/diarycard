import Foundation
import SwiftUI

enum Value: Codable, Hashable {
    case int(Int)
    case string(String)
    case bool(Bool)
    case date(Date)
    case stringArray([String])
    
    func unwrap<T>() -> T? {
        switch self {
            case .int(let v): return v as? T
            case .string(let v): return v as? T
            case .bool(let v): return v as? T
            case .date(let v): return v as? T
            case .stringArray(let v): return v as? T
        }
    }
    
    static func wrap<T>(_ value: T) -> Value? {
        switch value {
            case let v as Int: return .int(v)
            case let v as String: return .string(v)
            case let v as Bool: return .bool(v)
            case let v as Date: return .date(v)
            case let v as [String]: return .stringArray(v)
            default: return Value.wrap(String(describing: value))
        }
    }
    
    static func wrapOrDefault<T>(_ value: T) -> Value {
        return wrap(value).orDefaultTo(.nothing)
    }
    
    var kind: Kind {
        switch self {
            case .int: return .int
            case .string: return .string
            case .bool: return .bool
            case .date: return .date
            case .stringArray: return .stringArray
        }
    }
    
    enum Kind: Codable {
        case int
        case string
        case bool
        case date
        case stringArray
        
        func toString() -> String {
            String(describing: self)
        }
    }
    
    var asString: String {
        return unwrap() ?? ""
    }

    var asInt: Int {
        return unwrap() ?? 0
    }

    var asBool: Bool {
        return unwrap() ?? false
    }

    var asDate: Date {
        return unwrap() ?? Date()
    }

    var asStringArray: [String] {
        return unwrap() ?? []
    }
    
    func toString() -> String {
        switch self {
            case .int(let v): return String(v)
            case .string(let v): return v
            case .bool(let v): return String(v)
            case .date(let v):
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.string(from: v)
            case .stringArray(let v): return v.joined(separator: ",")
        }
    }
}
