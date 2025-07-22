import SwiftUI

struct ExportView: View {
    @State var start: Date = Date().goBack(1 * .week)
    @State var end: Date = Date()
    
    var body: some View {
        Text("Hello, world!")
    }
    
    var topBar: some View {
        Text("Top Bar")
    }
}
