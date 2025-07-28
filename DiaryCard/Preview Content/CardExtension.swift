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
            Card(date: getDate(from: "2025-07-25"), attributes: [
    //            "date": .date(getDate(from: "2025-06-25")),
                "text.comment": .string("Test commentTest commentTest commentTest comment"),
                
                "text.5-minute journal:fuck yeahs": .string("Fuck yeah!"),
                "text.5-minute journal:stressors": .string("Job"),
                "text.5-minute journal:gratitude": .string("Thanks Snowball <3"),
                
                "behaviour.self care": .int(3),
                "behaviour.suicidal ideation": .int(1),
                "behaviour.suicidal ideation:active": .bool(true),
                "behaviour.helplessness": .int(1),
                "behaviour.mindfulness": .int(1),
                "behaviour.emotion mind": .int(1),
                "behaviour.energy": .int(1),
                "behaviour.rumination": .int(1),
                
                "emotions.anxiety": .int(3),
                "emotions.sadness": .int(2),
                "emotions.love": .int(2),
                "emotions.frustration": .int(2),
                "emotions.happiness": .int(1),
                "emotions.overwhelm": .int(2),
                "emotions.loneliness": .int(2),
                
                "skills.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
                "skills.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
                "skills.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
                "skills.inter-personal effectiveness": .stringArray(["Clarify Priorities", "Validate Me"])
            ]),
            
            Card(date: getDate(from: "2025-07-24"), attributes: [
    //            "date": .date(getDate(from: "2025-06-24")),
                "text.comment": .string("Test commentTest commentTest commentTest comment"),
                
                "text.5-minute journal:fuck yeahs": .string("Fuck yeah!"),
                "text.5-minute journal:stressors": .string("Job"),
                "text.5-minute journal:gratitude": .string("Thanks Snowball <3"),
                
                "behaviour.self care": .int(3),
                "behaviour.suicidal ideation": .int(1),
                "behaviour.suicidal ideation:active": .bool(false),
                "behaviour.helplessness": .int(1),
                "behaviour.mindfulness": .int(1),
                "behaviour.emotion mind": .int(1),
                "behaviour.energy": .int(1),
                "behaviour.rumination": .int(6),
                
                "emotions.anxiety": .int(3),
                "emotions.sadness": .int(2),
                "emotions.love": .int(2),
                "emotions.frustration": .int(5),
                "emotions.happiness": .int(1),
                "emotions.overwhelm": .int(2),
                "emotions.loneliness": .int(9),
                
                "skills.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
                "skills.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
                "skills.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
                "skills.inter-personal effectiveness": .stringArray([])
            ]),
            
            Card(date: getDate(from: "2025-07-23"), attributes: [
    //            "date": .date(getDate(from: "2025-06-23")),
                "text.comment": .string("Test commentTest commentTest commentTest comment"),
                
                "text.5-minute journal:fuck yeahs": .string("Fuck yeah!"),
                "text.5-minute journal:stressors": .string("Job"),
                "text.5-minute journal:gratitude": .string("Thanks Snowball <3"),
                
                "behaviour.self care": .int(3),
                "behaviour.suicidal ideation": .int(1),
                "behaviour.suicidal ideation:active": .bool(false),
                "behaviour.helplessness": .int(1),
                "behaviour.mindfulness": .int(1),
                "behaviour.emotion mind": .int(1),
                "behaviour.energy": .int(1),
                "behaviour.rumination": .int(1),
                
                "emotions.anxiety": .int(3),
                "emotions.sadness": .int(12),
                "emotions.love": .int(2),
                "emotions.frustration": .int(2),
                "emotions.happiness": .int(1),
                "emotions.overwhelm": .int(2),
                "emotions.loneliness": .int(4),
                
                "skills.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
                "skills.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
                "skills.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
                "skills.inter-personal effectiveness": .stringArray(["Clarify Priorities", "Validate Me", "DEAR MAN"])
            ]),
            
            Card(date: getDate(from: "2025-07-22"), attributes: [
    //            "date": .date(getDate(from: "2025-06-25")),
                "text.comment": .string("Test commentTest commentTest commentTest comment"),
                
                "text.5-minute journal:fuck yeahs": .string("Fuck yeah!"),
                "text.5-minute journal:stressors": .string("Job"),
                "text.5-minute journal:gratitude": .string("Thanks Snowball <3"),
                
                "behaviour.self care": .int(3),
                "behaviour.suicidal ideation": .int(1),
                "behaviour.suicidal ideation:active": .bool(true),
                "behaviour.helplessness": .int(1),
                "behaviour.mindfulness": .int(1),
                "behaviour.emotion mind": .int(1),
                "behaviour.energy": .int(1),
                "behaviour.rumination": .int(1),
                
                "emotions.anxiety": .int(3),
                "emotions.sadness": .int(2),
                "emotions.love": .int(2),
                "emotions.frustration": .int(2),
                "emotions.happiness": .int(1),
                "emotions.overwhelm": .int(2),
                "emotions.loneliness": .int(2),
                
                "skills.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
                "skills.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
                "skills.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
                "skills.inter-personal effectiveness": .stringArray(["Clarify Priorities", "Validate Me"])
            ]),
            
            Card(date: getDate(from: "2025-07-21"), attributes: [
    //            "date": .date(getDate(from: "2025-06-24")),
                "text.comment": .string("Test commentTest commentTest commentTest comment"),
                
                "text.5-minute journal:fuck yeahs": .string("Fuck yeah!"),
                "text.5-minute journal:stressors": .string("Job"),
                "text.5-minute journal:gratitude": .string("Thanks Snowball <3"),
                
                "behaviour.self care": .int(3),
                "behaviour.suicidal ideation": .int(1),
                "behaviour.suicidal ideation:active": .bool(false),
                "behaviour.helplessness": .int(1),
                "behaviour.mindfulness": .int(1),
                "behaviour.emotion mind": .int(1),
                "behaviour.energy": .int(1),
                "behaviour.rumination": .int(6),
                
                "emotions.anxiety": .int(3),
                "emotions.sadness": .int(2),
                "emotions.love": .int(2),
                "emotions.frustration": .int(5),
                "emotions.happiness": .int(1),
                "emotions.overwhelm": .int(2),
                "emotions.loneliness": .int(9),
                
                "skills.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
                "skills.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
                "skills.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
                "skills.inter-personal effectiveness": .stringArray([])
            ]),
            
            Card(date: getDate(from: "2025-07-20"), attributes: [
    //            "date": .date(getDate(from: "2025-06-23")),
                "text.comment": .string("Oldest"),
                
                "text.5-minute journal:fuck yeahs": .string("Fuck yeah!"),
                "text.5-minute journal:stressors": .string("Job"),
                "text.5-minute journal:gratitude": .string("Thanks Snowball <3"),
                
                "behaviour.self care": .int(3),
                "behaviour.suicidal ideation": .int(1),
                "behaviour.suicidal ideation:active": .bool(false),
                "behaviour.helplessness": .int(1),
                "behaviour.mindfulness": .int(1),
                "behaviour.emotion mind": .int(1),
                "behaviour.energy": .int(1),
                "behaviour.rumination": .int(1),
                
                "emotions.anxiety": .int(3),
                "emotions.sadness": .int(12),
                "emotions.love": .int(2),
                "emotions.frustration": .int(2),
                "emotions.happiness": .int(1),
                "emotions.overwhelm": .int(2),
                "emotions.loneliness": .int(4),
                
                "skills.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
                "skills.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
                "skills.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
                "skills.inter-personal effectiveness": .stringArray(["Clarify Priorities", "Validate Me", "DEAR MAN"])
            ])
        ]
    }
}
