//
//  CardModel.swift
//  diarycard
//
//  Created by Sriram Rao on 6/25/25.
//

import Foundation

public struct Attribute: Codable, Identifiable, Hashable, Comparable {
    public var name: String
    public var value: String
    public var type: String
    public var id: String { name }
    
    init(name: String, value: String, type: String) {
        self.name = name
        self.value = value
        self.type = type
    }
    
    public static func == (lhs: Attribute, rhs: Attribute) -> Bool {
        return (lhs.name == rhs.name
            && lhs.value == rhs.value
            && lhs.type == rhs.type)
    }
    
    public static func < (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.value < rhs.value
    }
}

public struct Card: Codable, Identifiable, Comparable {
    public var attributes: [Attribute]
    public var id: String { UUID().uuidString }
    
    init(attributes: [Attribute]) {
        self.attributes = attributes
    }
    
    public func getValue(forAttributeName attribute: String) -> String {
        return attributes.first(where: { $0.name == attribute })?.value ?? ""
    }
    
    public mutating func setValue(_ value: String, forAttributeName attribute: String, type: String = "") {
        self.attributes.removeAll(where: { attribute == $0.name })
        self.attributes.append(Attribute(name: attribute, value: value, type: type))
    }
    
    public static func < (lhs: Card, rhs: Card) -> Bool {
        for i in 0..<lhs.attributes.count {
            if lhs.attributes[i] > rhs.attributes[i] {
                return false
            }
        }
        return true
    }
}
