//
//  Theme.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import SwiftUI

public enum Theme: String {
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle,
             .poppy, .seafoam, .sky, .tan, .teal, .yellow: return .black
        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
        }
    }
    
    var mainColor: Color {
        Color(rawValue)
    }
    
    var name: String {
        rawValue.capitalized
    }
    
    static func parse(themeName: String) -> Theme {
        return Theme(rawValue: themeName) ?? .indigo
    }
}
