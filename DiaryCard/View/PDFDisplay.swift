import Foundation
import PDFKit
import SwiftUI

struct PDFDisplay: UIViewRepresentable {
    typealias UIViewType = PDFView
    var url: URL
    @State var refresh: Bool
    
    func makeUIView(context: Context) -> UIViewType {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        
    }
}
