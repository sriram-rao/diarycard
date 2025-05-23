//
//  Section.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import Foundation


public struct MeasureGroup: Hashable, Codable {
    var title: String
    var properties: Dictionary<String, Int>
    
    init(title: String, properties: Dictionary<String, Int>) {
        self.title = title
        self.properties = properties
    }
}

public struct Card: Hashable, Codable {
    var date: Date
    var groups: [MeasureGroup]
    
    init(date: Date, groups: [MeasureGroup]) {
        self.date = date
        self.groups = groups
    }
}
