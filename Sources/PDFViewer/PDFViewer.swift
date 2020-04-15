//
//  PDFViewer.swift
//  PDFViewer
//
//  Created by Raju on 15/4/20.
//  Copyright © 2020 Raju. All rights reserved.
//

import SwiftUI
import PDFKit

public struct PDFViewer: View {
    @State private var pdfName: String = ""

    public init(pdfName: String) {
        self.pdfName = pdfName
    }
    public var body: some View {
        ZStack {
            PDFReaderView(pdfName: pdfName)
                .navigationBarTitle(pdfName)
        }
    }
}

struct PDFViewer_Previews: PreviewProvider {
    static var previews: some View {
        PDFViewer(pdfName: "")
            .previewLayout(.sizeThatFits)
    }
}

struct PDFReaderView : UIViewRepresentable {
    var pdfName: String = ""
    
    func makeUIView(context: Context) -> UIView {
        return setupPDFView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    private func setupPDFView() -> PDFView{
        let pdfView = PDFView()
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true)
        pdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pdfView.autoScales = true
        
        if let path = Bundle.main.url(forResource: pdfName, withExtension: "pdf"),
            let document = PDFDocument(url: path) {
            pdfView.document = document
        }
        return pdfView
    }
}
