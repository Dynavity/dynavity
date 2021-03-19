//
//  CanvasViewModel.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

class CanvasViewModel: ObservableObject {
    @Published var canvas = Canvas()
    @Published var selectedImage: UIImage?

    func addImageCanvasElement() {
        guard let image = selectedImage else {
            return
        }

        let imageCanvasElement = ImageCanvasElement(image: image)
        canvas.addElement(imageCanvasElement)

        // Reset the selected image.
        selectedImage = nil
    }

    func addPdfCanvasElement() {
        // TODO: Remove temporary URL for testing.
        guard let url = URL(string: "https://www.cs.cmu.edu/~avrim/451f11/lectures/lect1004.pdf") else {
            return
        }

        let pdfCanvasElement = PDFCanvasElement(url: url)
        canvas.addElement(pdfCanvasElement)
    }

    func addTextBlock() {
        canvas.addElement(TextBlock())
    }

    func addMarkUpTextBlock(markupType: MarkupTextBlock.MarkupType) {
        canvas.addElement(MarkupTextBlock(markupType: markupType))
    }
}
