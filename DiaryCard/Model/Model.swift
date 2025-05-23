//
//  Model.swift
//  diarycard
//
//  Created by Sriram Rao on 5/22/25.
//

import Foundation

@Observable
class Model{
    var cards: [Card] = loadCards("cards.json")
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

func loadCards(_ filename: String) -> [Card] {
    let cardData: [Card] = load(filename)
    return cardData.map({
        Card(
            date: Date.init(timeIntervalSince1970: $0.date.timeIntervalSinceReferenceDate),
            groups: $0.groups
        )
    })
}
