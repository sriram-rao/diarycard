import Foundation
import SwiftData
import OrderedCollections

public class Schema {
    static let attributes: OrderedDictionary<String, Value> = [
        "text.1.comment": .string("Placeholder"),
        
        "text.2.5-minute journal:fuck yeahs": .string(""),
        "text.3.5-minute journal:stressors": .string("Job"),
        "text.4.5-minute journal:gratitude": .string(""),
        
        "behaviour.1.energy": .int(1),
        "behaviour.2.self care": .int(4),
        "behaviour.3.mindfulness": .int(5),
        "behaviour.4.emotion mind": .int(3),
        "behaviour.5.rumination": .int(5),
        "behaviour.6.helplessness": .int(3),
        "behaviour.7.suicidal ideation": .int(4),
        "behaviour.7.suicidal ideation:active": .bool(false),
        
        "emotions.1.anxiety": .int(3),
        "emotions.2.frustration": .int(4),
        "emotions.3.overwhelm": .int(4),
        "emotions.4.loneliness": .int(5),
        "emotions.5.sadness": .int(3),
        "emotions.6.love": .int(5),
        "emotions.7.happiness": .int(1),
        
        "skills.1.distress tolerance": .stringArray(["ACCEPTS", "STOP"]),
        "skills.2.core mindfulness": .stringArray(["Observe", "Wise Mind"]),
        "skills.3.emotion regulation": .stringArray(["Build Mastery"]),
        "skills.4.inter-personal effectiveness": .stringArray(["Validate Me"])
    ]
    
    static var card: Card {
        Card(date: Date.today, attributes: Schema.get())
    }
    
    static func get() -> Dictionary<String, Value> {
        attributes.reduce([:], {dict, pair in
            var dict = dict
            dict[pair.key.key] = pair.value
            return dict
        })
    }
    
    static var attributeNames: Array<String> { getAttributeNames() }
    
    static func getAttributeNames() -> [String] {
        Array(attributes.keys.sorted())
    }
    
    static func getKeysIf(excluded: Bool = false, inGroup: String) -> [String] {
        attributeNames.filter { $0.belongsTo(inGroup) == not(excluded) }
    }
    
    static func getKeysIf(type valueType: Value.Kind) -> [String] {
        getKeysIf(types: [valueType])
    }
    
    static func getKeysIf(include: Bool = true, types valueTypes: [Value.Kind]) -> [String] {
        Schema.attributes.filter({ valueTypes.contains($0.value.kind) == include }).keys.elements
    }
    
    static func getKeysIf(_ predicate: (String) -> Bool) -> [String] {
        Schema.attributeNames.filter(predicate)
    }
}

let Skills = [
        "skills.distress tolerance": ["ACCEPTS", "IMPROVE", "STOP", "Pros & Cons", "TIPP", "GRACE", "Radical Acceptance"],
        "skills.core mindfulness": ["Wise Mind", "Observe", "Describe", "Participate", "Non-Judgemental Stance", "One Mindful", "Effective"],
        "skills.emotion regulation": ["(Ac.) Short-Term +","(Ac.) Long-Term +", "(B)uild Mastery",
                                      "(C)ope Ahead", "PLEASE", "Check The Facts", "Opposite Action", "Let Go of Suffering"],
        "skills.inter-personal effectiveness": ["Clarify Priorities", "DEAR MAN", "GIVE", "FAST",
                                               "Validate Me", "Validate Others", "Challenge Self-Judgement"]
    ]
