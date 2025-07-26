import SwiftUI

class Summary {
    public var name: String
    public var data: [Date: Value]
    
    public init(of name: String, as values: [Date: Value]) {
        self.name = name
        self.data = values
    }
    
    static func create(for attribute: String, from cards: [Card]) -> Summary {
        let attribute = attribute.key
        let summary = Summary(of: attribute, as: cards.reduce(into: [:]){ result, card in
            result[card.date] = card[attribute]
        })
        return summary
    }
    
    public var keys: [Date] {
        return Array(data.keys)
    }
    
    public var values: [Value] {
        return Array(data.values)
    }
}
