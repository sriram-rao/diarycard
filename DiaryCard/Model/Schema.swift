import Foundation
import SwiftData
import OrderedCollections

public class Schema {
    static let attributes: OrderedDictionary<String, Value> = [
        "text.1.comment": .string("Placeholder"),
        
        "text.2.5-minute journal:fuck yeahs": .string(""),
        "text.3.5-minute journal:stressors": .string("Job"),
        "text.4.5-minute journal:gratitude": .string("Thanks Snowball <3"),
        
        "behaviour.1.energy": .int(1),
        "behaviour.2.self care": .int(4),
        "behaviour.3.mindfulness": .int(5),
        "behaviour.4.emotion mind": .int(2),
        "behaviour.5.rumination": .int(4),
        "behaviour.6.helplessness": .int(3),
        "behaviour.7.suicidal ideation": .int(3),
        "behaviour.7.suicidal ideation:active": .bool(false),
        
        "emotions.1.anxiety": .int(3),
        "emotions.2.frustration": .int(3),
        "emotions.3.overwhelm": .int(4),
        "emotions.4.loneliness": .int(3),
        "emotions.5.sadness": .int(3),
        "emotions.6.love": .int(4),
        "emotions.7.happiness": .int(1),
        
        "skills.1.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
        "skills.2.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
        "skills.3.emotion regulation": .stringArray(["Positives", "Opposite Action"]),
        "skills.4.inter-personal effectiveness": .stringArray(["Clarify Priorities", "Validate Me", "DEAR MAN"])
    ]
    
    static var card: Card {
        Card(date: Date.today, attributes: Schema.get())
    }
    
    static func get() -> Dictionary<String, Value> {
        return attributes.reduce([:], {dict, pair in
            var dict = dict
            dict[pair.key.key] = pair.value
            return dict
        })
    }
    
    static var attributeNames: Array<String> { getAttributeNames() }
    
    static func getAttributeNames() -> [String] {
        Array(attributes.keys.sorted())
    }
    
    static func getKeysOf(group: String, excluded: Bool = false) -> [String] {
        attributeNames.filter { $0.belongsTo(group) == not(excluded) }
    }
}

let Skills = [
        "skills.distress tolerance": ["ACCEPTS", "IMPROVE", "STOP", "Pros & Cons", "TIPP", "GRACE", "Radical Acceptance"],
        "skills.core mindfulness": ["Wise Mind", "Observe", "Describe", "Participate", "Non-Judgemental Stance", "One Mindful", "Effective"],
        "skills.emotion regulation": ["Accumulate Short-Term Positives","Accumulate Long-Term Positives", "Build Mastery",
                                      "Cope Ahead", "PLEASE", "Check The Facts", "Opposite Action", "Let Go of Suffering"],
        "skills.inter-personal effectiveness": ["Clarify Priorities", "DEAR MAN", "GIVE", "FAST",
                                               "Validate Me", "Validate Others", "Challenge Self-Judgement"]
    ]
