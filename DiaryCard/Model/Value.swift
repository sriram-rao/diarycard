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
        case .int(let val): return val as? T
        case .string(let val): return val as? T
        case .bool(let val): return val as? T
        case .date(let val): return val as? T
        case .stringArray(let val): return val as? T
        }
    }

    static func wrap<T>(_ value: T) -> Value? {
        switch value {
        case let val as Int: return .int(val)
        case let val as String: return .string(val)
        case let val as Bool: return .bool(val)
        case let val as Date: return .date(val)
        case let val as [String]: return .stringArray(val)
        default: return Value.wrap(String(describing: value))
        }
    }

    static func wrapOrDefault<T>(_ value: T) -> Value {
        return wrap(value).orUse(Value.nothing)
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
        return unwrap().orUse(.nothing)
    }

    var asInt: Int {
        return unwrap().orUse(0)
    }

    var asBool: Bool {
        return unwrap().orUse(false)
    }

    var asDate: Date {
        return unwrap().orUse(.today)
    }

    var asStringArray: [String] {
        return unwrap().orUse([])
    }

    func toString() -> String {
        switch self {
        case .int(let v): return String(v)
        case .string(let v): return v
        case .bool(let v): return v ? "Yes" : "No"
        case .date(let v): return v.toString()
        case .stringArray(let v): return v.joined(separator: .comma)
        }
    }
    
    static let nothing: Value = .string(.nothing)
}
