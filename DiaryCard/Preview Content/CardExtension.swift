//
//  CardExtension.swift
//  diarycard
//
//  Created by Sriram Rao on 6/26/25.
//
import Foundation

extension Card {
    static let sampleData: [Card] = [
        Card(date: Date(),
             attributes:
                [
                    Attribute(name: "Date", value: "2025-06-25", type: "Date"),
                    Attribute(name: "Text.Comment", value: "Test commentTest commentTest commentTest comment", type: "String"),
                    Attribute(name: "Behaviour.Self Care", value: "3", type: "Number"),
                    Attribute(name: "Behaviour.Suicidal Ideation", value: "1", type: "Number"),
                    Attribute(name: "Behaviour.Active SI", value: "0", type: "Number"),
                    Attribute(name: "Emotions.Anxiety", value: "3", type: "Number"),
                    Attribute(name: "Emotions.Happiness", value: "1", type: "Number"),
                    Attribute(name: "Emotions.Sadness", value: "2", type: "Number"),
                    Attribute(name: "Skills.Distress Tolerance", value: "ACCEPTS, IMPROVE, STOP", type: "List:ACCEPTS,IMPROVE,TIPP,STOP"),
                ]
            ),
        Card(date: Date().addingTimeInterval(-24*60*60),
             attributes:
                [
                    Attribute(name: "Date", value: "2025-06-24", type: "Date"),
                    Attribute(name: "Text.Comment", value: "Test comment 2", type: "String"),
                    Attribute(name: "Behaviour.Self Care", value: "3", type: "Number"),
                    Attribute(name: "Behaviour.Suicidal Ideation", value: "1", type: "Number"),
                    Attribute(name: "Behaviour.Active SI", value: "0", type: "Number"),
                    Attribute(name: "Emotions.Anxiety", value: "3", type: "Number"),
                    Attribute(name: "Emotions.Happiness", value: "1", type: "Number"),
                    Attribute(name: "Emotions.Sadness", value: "2", type: "Number"),
                    Attribute(name: "Skills.Distress Tolerance", value: "ACCEPTS, IMPROVE, STOP", type: "List:ACCEPTS,IMPROVE,TIPP,STOP"),
                ]
            ),
        Card(date: Date().addingTimeInterval(-2*24*60*60),
             attributes:
                [
                    Attribute(name: "Date", value: "2025-06-23", type: "Date"),
                    Attribute(name: "Text.Comment", value: "Test comment 3", type: "String"),
                    Attribute(name: "Behaviour.Self Care", value: "3", type: "Number"),
                    Attribute(name: "Behaviour.Suicidal Ideation", value: "1", type: "Number"),
                    Attribute(name: "Behaviour.Active SI", value: "False", type: "Boolean"),
                    Attribute(name: "Emotions.Anxiety", value: "3", type: "Number"),
                    Attribute(name: "Emotions.Happiness", value: "1", type: "Number"),
                    Attribute(name: "Emotions.Sadness", value: "2", type: "Number"),
                    Attribute(name: "Skills.Distress Tolerance", value: "ACCEPTS, IMPROVE, STOP", type: "List:ACCEPTS, IMPROVE, TIPP, STOP"),
                ]
            ),
    ]
}
