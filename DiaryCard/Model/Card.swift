//
//  Card.swift
//  diarycard
//
//  Created by Sriram Rao on 6/26/25.
//
import Foundation
import SwiftData

@Model
class Attribute: Comparable, Identifiable {
    var name: String
    var value: String
    var type: String
    var id: String { name }
    
    init(name: String, value: String, type: String) {
        self.name = name
        self.value = value
        self.type = type
    }
    
    static func < (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.name < rhs.name
    }
}

@Model
class Card: Identifiable {
    var id: UUID
    var date: Date
    var attributes: [Attribute]
    
    init(id: UUID = UUID(), date: Date = Date(), attributes: [Attribute]) {
        self.id = id
        self.date = date
        self.attributes = attributes
    }
}
