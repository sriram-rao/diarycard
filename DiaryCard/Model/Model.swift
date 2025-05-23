//
//  Model.swift
//  diarycard
//
//  Created by Sriram Rao on 5/22/25.
//

import Foundation

@Observable
class Model{
    var cards: [Card] = load("cards.json")
    
    func correctedCards() -> [Card] {
        return cards.map({
            Card(
                date: Date.init(timeIntervalSince1970: $0.date.timeIntervalSinceReferenceDate),
                groups: $0.groups
            )
        })
    }
}


func load<T: Decodable>(_ filename: String) -> T {

    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)

    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
