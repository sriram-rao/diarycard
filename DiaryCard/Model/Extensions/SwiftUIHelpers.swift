import SwiftData
import OrderedCollections
import SwiftUI

extension View {
    func checkIf(
        _ condition: Bool, then showView: () -> some View,
        otherwise showDefault: () -> some View = { EmptyView() }
    ) -> AnyView {
        condition ? AnyView(showView()) : AnyView(showDefault())
    }

    func blackAndWhite(theme: ColorScheme) -> some View {
        self.foregroundStyle((theme == ColorScheme.light ? Color.black : .white).opacity(0.75))
    }

    func onAppearOrChange<V>(of first: V, or second: V, _ action: @escaping () -> Void) -> some View
    where V: Equatable {
        return self.onAppear { action() }
            .onChange(of: first) { action() }
            .onChange(of: second) { action() }
    }

    func blurIf(_ condition: Bool) -> some View {
        self.blur(radius: 3 * (condition ? 1 : 0))
    }

    func fetch(from start: Date, to end: Date, in context: ModelContext) -> [Card] {
        let fetcher = FetchDescriptor<Card>(
            predicate: #Predicate { $0.date >= start.startOfDay && $0.date <= end.startOfDay }
        )
        return (try? context.fetch(fetcher)).orUse([])
            .sorted(by: {card1, card2 in card1.date > card2.date})
    }
    
    func fetchUnique(from start: Date, to end: Date, in context: ModelContext) -> OrderedSet<Card> {
        OrderedSet(fetch(from: start, to: end, in: context))
    }

    func minimalStyle() -> some View {
        self.buttonStyle(Minimal())
            .frame(alignment: .center)
    }
    
    func linkButtonStyle(colour: Color, backgroundOpacity: Double = 0.1, colourScheme: ColorScheme = .light) -> some View {
        self.padding(7.5)
            .buttonStyle(.borderless)
            .tint(colour)
            .background( RoundedRectangle(cornerRadius: 7.5).fill(
                colourScheme == .dark && colour == .secondary ? Color.white :
                colour.opacity(backgroundOpacity)) )
    }
}

struct Minimal: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
            .padding(15)
            .background(.ultraThinMaterial)
            .foregroundStyle(.blue)
            .clipShape(Circle())
    }
}

public enum Theme: String, CaseIterable {
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
    case offwhite

    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle,
            .poppy, .seafoam, .sky, .tan, .teal, .yellow, .offwhite:
            return .black
        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
        }
    }

    var mainColor: Color {
        Color(rawValue)
    }

    var name: String {
        rawValue.capitalized
    }
}

extension Color {
    static var offwhite: Color {
        return Color(red: 0xF5, green: 0xF5, blue: 0xF5, opacity: 1)
    }
    
    static func themed(_ theme: ColorScheme, light: Color, dark: Color) -> Color {
        theme == .light ? light : dark
    }
}
