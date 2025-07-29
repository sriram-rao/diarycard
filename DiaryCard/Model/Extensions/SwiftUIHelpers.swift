import SwiftUI
import SwiftData

extension View {
    func checkIf(_ condition: Bool, then showView: () -> some View,
               otherwise showDefault: () -> some View = { EmptyView() }) -> AnyView {
        condition ? AnyView(showView()) : AnyView(showDefault())
    }
    
    func getBinding(for keyPath: WritableKeyPath<DateInterval, Date>,
                    from interval: Binding<DateInterval>) -> Binding<Date> {
        return Binding<Date>(
            get: { interval.wrappedValue[keyPath: keyPath] },
            set: { interval.wrappedValue[keyPath: keyPath] = $0 }
        )
    }
    
    func blackAndWhite(theme: ColorScheme) -> some View {
        self.foregroundStyle((theme == ColorScheme.light ? Color.black : .white).opacity(0.75))
    }
    
    func onAppearOrChange<V>(of first: V, or second: V, _ action: @escaping () -> Void) -> some View where V : Equatable {
        return self.onAppear { action() }
            .onChange(of: first) { action() }
            .onChange(of: second) { action() }
    }
    
    func onAppearOrChange<V>(of first: V, _ action: @escaping () -> Void) -> some View where V : Equatable {
        return self.onAppear { action() }
            .onChange(of: first) { action() }
    }
    
    func blurIf(_ condition: Bool) -> some View {
        self.blur(radius: 3 * (condition ? 1 : 0))
    }
    
    func fetch(from start: Date, to end: Date, in context: ModelContext) -> [Card] {
        let fetcher = FetchDescriptor<Card>(
            predicate: #Predicate { $0.date >= start && $0.date <= end },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return (try? context.fetch(fetcher)).orDefaultTo([])
    }
    
    func minimalStyle() -> some View {
        self.buttonStyle(Minimal())
            .frame(alignment: .center)
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
