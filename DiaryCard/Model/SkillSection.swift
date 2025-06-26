//
//  SkillSection.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import Foundation

public struct SkillSection {
    var title: String
    var skills: Dictionary<String, Bool>
    var theme: Theme
}

extension SkillSection {
    static let sample: [SkillSection] = [
        SkillSection(title: "Distress Tolerance",
                     skills: [
                        "ACCEPTS": true,
                        "IMPROVE": false,
                        "TIPP": false
                     ],
                     theme: .poppy
        ),
        SkillSection(title: "Core Mindfulness",
                     skills: [
                        "Observe": true,
                        "Describe": false
                     ],
                     theme: .navy
        )
    ]
}

public struct MeasureGroup: Hashable, Codable {
    var title: String
    var properties: Dictionary<String, Int>
    
    init(title: String, properties: Dictionary<String, Int>) {
        self.title = title
        self.properties = properties
    }
}

public struct Card2: Hashable, Codable {
    var date: Date
    var groups: [MeasureGroup]
    
    init(date: Date, groups: [MeasureGroup]) {
        self.date = date
        self.groups = groups
    }
}
