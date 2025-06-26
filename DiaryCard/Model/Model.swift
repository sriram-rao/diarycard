//
//  Model.swift
//  diarycard
//
//  Created by Sriram Rao on 5/22/25.
//

import Foundation

@Observable
class Model{
    static let dateReadFormat: String = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    var cards: [Dictionary<String, String>] = loadCards("cards 2.json")
    var schema: Dictionary<String, String> = load("schema.json")
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

func loadCards(_ filename: String) -> [Dictionary<String, String>] {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = Model.dateReadFormat
    var cards: [Dictionary<String, String>] = load(filename)
    cards = cards.sorted { formatter.date(from: $0["Date"] ?? "")! > formatter.date(from: $1["Date"] ?? "")! }
    return cards
}
