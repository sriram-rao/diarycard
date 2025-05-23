//
//  Section.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import Foundation

public struct CardSection {
    var title: String
    var properties: Dictionary<String, Item>
}

extension CardSection {
    static let sample: [CardSection] = [
        CardSection(title: "Behaviour", properties: [
            "Self Care": 3,
            "Suicidal Ideation": 1,
            "Active SI": false
        ]),
        CardSection(title: "Emotions", properties: [
            "Anxiety": 3,
            "Happiness": 1,
            "Sadness": 2
        ])
    ]
}
