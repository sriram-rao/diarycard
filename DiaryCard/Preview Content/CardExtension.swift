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
                "text.1.comment": .string("Test commentTest commentTest commentTest comment"),
                
                "text.2.5minjournal.fuck yeahs": .string("Fuck yeah!"),
                "text.3.5minjournal.stressors": .string("Job"),
                "text.4.5minjournal.gratitude": .string("Thanks Snowball <3"),
                
                "behaviour.1.self care": .int(3),
                "behaviour.2.suicidal ideation": .int(1),
                "behaviour.2.suicidal ideation.active": .bool(true),
                "behaviour.4.helplessness": .int(1),
                "behaviour.5.mindfulness": .int(1),
                "behaviour.6.emotion mind": .int(1),
                "behaviour.7.energy": .int(1),
                "behaviour.8.rumination": .int(1),
                
                "emotions.1.anxiety": .int(3),
                "emotions.2.sadness": .int(2),
                "emotions.3.love": .int(2),
                "emotions.4.frustration": .int(2),
                "emotions.5.happiness": .int(1),
                "emotions.6.overwhelm": .int(2),
                "emotions.7.loneliness": .int(2),
                
                "skills.1.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
                "skills.2.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
                "skills.3.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
                "skills.4.inter-personal effectiveness": .stringArray(["Clarify Priorities", "Validate Me"])
            ]),
            
            Card(date: getDate(from: "2025-06-24"), attributes: [
    //            "date": .date(getDate(from: "2025-06-24")),
                "text.1.comment": .string("Test commentTest commentTest commentTest comment"),
                
                "text.2.5minjournal.fuck yeahs": .string("Fuck yeah!"),
                "text.3.5minjournal.stressors": .string("Job"),
                "text.4.5minjournal.gratitude": .string("Thanks Snowball <3"),
                
                "behaviour.1.self care": .int(3),
                "behaviour.2.suicidal ideation": .int(1),
                "behaviour.2.suicidal ideation.active": .bool(false),
                "behaviour.4.helplessness": .int(1),
                "behaviour.5.mindfulness": .int(1),
                "behaviour.6.emotion mind": .int(1),
                "behaviour.7.energy": .int(1),
                "behaviour.8.rumination": .int(1),
                
                "emotions.1.anxiety": .int(3),
                "emotions.2.sadness": .int(2),
                "emotions.3.love": .int(2),
                "emotions.4.frustration": .int(2),
                "emotions.5.happiness": .int(1),
                "emotions.6.overwhelm": .int(2),
                "emotions.7.loneliness": .int(2),
                
                "skills.1.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
                "skills.2.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
                "skills.3.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
                "skills.4.inter-personal effectiveness": .stringArray([])
            ]),
            
            Card(date: getDate(from: "2025-06-23"), attributes: [
    //            "date": .date(getDate(from: "2025-06-23")),
                "text.1.comment": .string("Test commentTest commentTest commentTest comment"),
                
                "text.2.5minjournal.fuck yeahs": .string("Fuck yeah!"),
                "text.3.5minjournal.stressors": .string("Job"),
                "text.4.5minjournal.gratitude": .string("Thanks Snowball <3"),
                
                "behaviour.1.self care": .int(3),
                "behaviour.2.suicidal ideation": .int(1),
                "behaviour.2.suicidal ideation.active": .bool(false),
                "behaviour.4.helplessness": .int(1),
                "behaviour.5.mindfulness": .int(1),
                "behaviour.6.emotion mind": .int(1),
                "behaviour.7.energy": .int(1),
                "behaviour.8.rumination": .int(1),
                
                "emotions.1.anxiety": .int(3),
                "emotions.2.sadness": .int(2),
                "emotions.3.love": .int(2),
                "emotions.4.frustration": .int(2),
                "emotions.5.happiness": .int(1),
                "emotions.6.overwhelm": .int(2),
                "emotions.7.loneliness": .int(2),
                
                "skills.1.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
                "skills.2.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
                "skills.3.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
                "skills.4.inter-personal effectiveness": .stringArray(["Clarify Priorities", "Validate Me", "DEAR MAN"])
            ])
        ]
    }
}

extension ListSchemas {
    static func getSampleData() -> ListSchemas {
        return ListSchemas(schemas: [
            "skills.1.distress tolerance": ["ACCEPTS", "IMPROVE", "TIPP", "STOP"],
            "skills.2.core mindfulness": ["Observe", "Wise Mind", "Describe", "Participate"],
            "skills.3.emotion regulation": ["Positives", "Check the facts", "Opposite Action"],
            "skills.4.inter-personal effectiveness": ["Clarify Priorities", "DEAR MAN", "GIVE", "FAST",
                                                   "Validate Me", "Validate Others", "Challenge Self-Judgement"]
        ])
    }
}
