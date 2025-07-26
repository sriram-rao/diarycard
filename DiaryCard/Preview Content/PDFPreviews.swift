import SwiftData
import SwiftUI

#Preview("Summary View", traits: .cardSampleData) {
    SummaryView()
}

#Preview("PDF Display", traits: .cardSampleData) {
    let file = URL(fileURLWithPath: "/Users/sriramrao/Documents/My Docs/Employment/Job Applications/Sriram_Rao_Resume.pdf")
    PDFDisplay(url: file, refresh: true)
}
