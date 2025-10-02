import SwiftUI

#Preview("Bool") {
    @Previewable @State var value: Bool = false
    Text(verbatim: "Live Preview: \(value)")
    BooleanView(value: $value)
}

#Preview("Home Button") {
    HomeButton()
}

#Preview("Date") {
    @Previewable @State var value: Date = Date()
    Text(verbatim: "Live Preview: \(value.formatted())\n")
    Spacer()
    DateView(value: $value)
    Spacer()
}

#Preview("Date Picker", traits: .cardSampleData) {
    @Previewable @State var value: Date = Date().goBack(1 * .week)
    @Previewable @State var path = NavigationPath()
    Text(verbatim: "Live Preview: \(value.formatted())\n")
    Spacer()
    NavigationStack(path: $path) {
        DateView(value: $value)
    }
    Spacer()
}

// TapBackground preview removed - now using native SwiftUI materials
