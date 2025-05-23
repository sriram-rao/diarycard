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
}

extension SkillSection {
    static let sample: [SkillSection] = [
        SkillSection(title: "Distress Tolerance", skills: [
            "ACCEPTS": true,
            "IMPROVE": false,
            "TIPP": false
        ]),
        SkillSection(title: "Core Mindfulness", skills: [
            "Observe": true,
            "Describe": false
        ])
    ]
}
