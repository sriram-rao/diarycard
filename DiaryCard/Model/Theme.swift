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
    case indigos
    case lavender
    case magentas
    case navy
    case oranges
    case oxblood
    case periwinkle
    case poppy
    case purples
    case seafoam
    case sky
    case tan
    case teals
    case yellows
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .oranges, .periwinkle,
             .poppy, .seafoam, .sky, .tan, .teals, .yellows: return .black
        case .indigos, .magentas, .navy, .oxblood, .purples: return .white
        }
    }
    
    var mainColor: Color {
        Color(rawValue)
    }
    
    var name: String {
        rawValue.capitalized
    }
    
    static func parse(themeName: String) -> Theme {
        return Theme(rawValue: themeName) ?? .indigos
    }
}
