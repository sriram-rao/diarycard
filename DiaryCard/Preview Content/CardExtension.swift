//
//  CardExtension.swift
//  diarycard
//
//  Created by Sriram Rao on 6/26/25.
//
import Foundation

extension Card {
    private static let formatter = DateFormatter()
    private static func getDate(from: String) -> Date {
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: from)!
    }
    
    static func getSampleData() -> [Card] {
        return [
            Card(date: getDate(from: "2025-06-25"), attributes: [
    //            "date": .date(getDate(from: "2025-06-25")),
                "text.comment": .string("Test commentTest commentTest commentTest comment"),
                "behaviour.self care": .int(3),
                "behaviour.suicidal ideation": .int(1),
                "behaviour.active si": .int(0),
                "emotions.anxiety": .int(3),
                "emotions.happiness": .int(1),
                "emotions.sadness": .int(2),
                "skills.distress tolerance": .stringArray(["ACCEPTS", "STOP"])
            ]),
            
            Card(date: getDate(from: "2025-06-24"), attributes: [
    //            "date": .date(getDate(from: "2025-06-24")),
                "text.comment": .string("Test comment 2"),
                "behaviour.self care": .int(3),
                "behaviour.suicidal ideation": .int(1),
                "behaviour.active si": .int(0),
                "emotions.anxiety": .int(3),
                "emotions.happiness": .int(1),
                "emotions.sadness": .int(2),
                "skills.distress tolerance": .stringArray(["STOP"])
            ]),
            
            Card(date: getDate(from: "2025-06-23"), attributes: [
    //            "date": .date(getDate(from: "2025-06-23")),
                "text.comment": .string("Test comment 3"),
                "behaviour.self care": .int(3),
                "behaviour.suicidal ideation": .int(1),
                "behaviour.active si": .bool(false),
                "emotions.anxiety": .int(3),
                "emotions.happiness": .int(1),
                "emotions.sadness": .int(2),
                "skills.distress tolerance": .stringArray(["ACCEPTS", "IMPROVE", "STOP"])
            ])
        ]
    }
}

extension ListSchemas {
    static func getSampleData() -> ListSchemas {
        return ListSchemas(schemas: [
            "skills.distress tolerance": ["ACCEPTS", "IMPROVE", "TIPP", "STOP"]
        ])
    }
}
