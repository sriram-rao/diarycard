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
    case offwhite
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .oranges, .periwinkle,
                .poppy, .seafoam, .sky, .tan, .teals, .yellows, .offwhite: return .black
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

extension Color {
    static var offwhite: Color {
        return Color(red: 0xF5, green: 0xF5, blue: 0xF5, opacity: 1)
    }
}
