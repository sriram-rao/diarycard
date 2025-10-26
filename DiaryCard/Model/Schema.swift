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
        "skills.3.emotion regulation": .stringArray(["Accumulate Short-Term +"]),
        "skills.4.interpersonal effectiveness": .stringArray(["Validate Me"])
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
    
    static let changes: [String: String] = [
        "skills.inter-personal effectiveness": "skills.interpersonal effectiveness",
    ]
}

struct SkillItem: Codable, Hashable {
    let name: String
    let description: String
}

let Skills: [String: [SkillItem]] = [
    "skills.distress tolerance": [
        SkillItem(name: "ACCEPTS", description: "Use Activities, Contributing, Comparisons, Emotions, Pushing away, and Thoughts/Sensations to distract and tolerate distress."),
        SkillItem(name: "IMPROVE", description: "Improve the moment with imagery, meaning, prayer, relaxation, one thing in the moment, vacation, and encouragement."),
        SkillItem(name: "STOP", description: "Stop, Take a step back, Observe, and Proceed mindfully to prevent impulsive reactions."),
        SkillItem(name: "Pros & Cons", description: "List pros and cons of acting on urges vs. using skills; review before acting."),
        SkillItem(name: "TIPP", description: "Temperature, Intense exercise, Paced breathing, and Progressive muscle relaxation to quickly reduce arousal."),
        SkillItem(name: "GRACE", description: "A gentle way to sit with painful emotions: Ground yourself, Reflect on feelings, Affirmations, add Comfort, and change your Environment."),
        SkillItem(name: "Radical Acceptance", description: "Accept reality as it is, fully and completely, to reduce suffering and move forward effectively.")
    ],
    "skills.core mindfulness": [
        SkillItem(name: "Wise Mind", description: "Integrate emotion mind and reasonable mind to act from inner wisdom."),
        SkillItem(name: "Observe", description: "Notice experiences without trying to change them; attend to sensations, thoughts, and feelings."),
        SkillItem(name: "Describe", description: "Put words on experiences objectively and nonjudgmentally."),
        SkillItem(name: "Participate", description: "Enter into the experience fully; be present and engaged."),
        SkillItem(name: "Non-Judgemental Stance", description: "See without judging; replace evaluations with facts."),
        SkillItem(name: "One Mindful", description: "Do one thing at a time with full awareness."),
        SkillItem(name: "Effective", description: "Focus on what works to reach goals rather than on what’s right or fair.")
    ],
    "skills.emotion regulation": [
        SkillItem(name: "Accumulate Long-Term +", description: "Plan and build long-term positive experiences to enrich life."),
        SkillItem(name: "Accumulate Short-Term +", description: "Schedule small, daily positive activities to boost mood."),
        SkillItem(name: "Build Mastery", description: "Do things that make you feel competent and capable; set achievable challenges."),
        SkillItem(name: "Cope Ahead", description: "Rehearse coping strategies for challenging situations before they occur."),
        SkillItem(name: "PLEASE", description: "Treat Physical illness, balance Eating, avoid mood-Altering substances, balance Sleep, and get Exercise."),
        SkillItem(name: "Check The Facts", description: "Evaluate whether emotions fit the facts and are effective for the situation."),
        SkillItem(name: "Opposite Action", description: "Act opposite to emotion urges when emotions don’t fit the facts or are unhelpful."),
        SkillItem(name: "Let Go of Suffering", description: "Reduce secondary suffering by releasing attachment to painful thoughts and feelings.")
    ],
    "skills.interpersonal effectiveness": [
        SkillItem(name: "Clarify Priorities", description: "Decide whether your goal is objective, relationship, or self-respect to guide your approach."),
        SkillItem(name: "DEAR MAN", description: "Describe, Express, Assert, Reinforce; stay Mindful, appear confident (Appear), and negotiate (Negotiate)."),
        SkillItem(name: "GIVE", description: "Be Gentle, act Interested, Validate, and use an Easy manner to maintain relationships."),
        SkillItem(name: "FAST", description: "Be Fair, no (over)Apologies, Stick to values, and be Truthful for self-respect."),
        SkillItem(name: "Validate Me", description: "Self-validate your feelings and experiences to reduce shame and build resilience."),
        SkillItem(name: "Validate Others", description: "Communicate that another’s feelings and experiences are understandable and make sense."),
        SkillItem(name: "Challenge Self-Judgement", description: "Identify and question harsh self-judgments; replace with balanced, factual statements.")
    ]
]

let FieldDescriptions: [String: String] = [
    "text.comment": "A brief note",
    "text.5-minute journal:fuck yeahs": "Esteemable acts",
    "text.5-minute journal:stressors": "What bothered me",
    "text.5-minute journal:gratitude": "Made me feel thankful",

    "behaviour.energy": "(0 = low, 5 = normal, 10 = high)",
    "behaviour.self care": "Did I take care of myself? (0 = none, 5 = average, 10 = well)",
    "behaviour.mindfulness": "Were there mindful moments (0 = none, 5 = regular (is good), 10 = many)",
    "behaviour.emotion mind": "How much did I feel emotion  mind? (0 = none, 5 = many moments, 10 = the whole day)",
    "behaviour.rumination": "Cycle of ineffective thoughts (0 = none, 5 = possible issue, 10 = constantly)",
    "behaviour.helplessness": "Helpless or feeling like a victim (0 = not at all, 5 = possible issue, 10 = fully)",
    "behaviour.suicidal ideation": "Wanting to be dead? (0 = none, 10 = dead, therefore impossible)",
    "behaviour.suicidal ideation:active": "Did I want to act on SI urges?",

    "emotions.anxiety": "Anxious, worried, or nervous feelings (0 = none, 10 = >= 1 full-blown attack)",
    "emotions.frustration": "Frustration or irritation (0 = none, 5 = annoyed, 10 = rage)",
    "emotions.overwhelm": "Overwhelmed by work or emotion? (0 = none, 5 = whelmed (bad), 10 = a lot)",
    "emotions.loneliness": "Missing other people, lack of romance (0 = none, 5 = problem, 10 = aching/pining)",
    "emotions.sadness": "Low, cry (0 = none, 5 = very, 10 = severe)",
    "emotions.love": "Affection, warm, or connected feelings (0 = none, 5 = lots, 10 = very intense)",
    "emotions.happiness": "Joy, contentness, positivity, optimism (0 = none, 5 = happy day, 10 = ecstatic)"
]
