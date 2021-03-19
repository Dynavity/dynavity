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
    @Published var selectedFile: URL?

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
        guard let file = selectedFile else {
            return
        }

        let pdfCanvasElement = PDFCanvasElement(file: file)
        canvas.addElement(pdfCanvasElement)

        // Reset the selected file.
        selectedFile = nil
    }

    func addTextBlock() {
        canvas.addElement(TextBlock())
    }

    func addMarkUpTextBlock(markupType: MarkupTextBlock.MarkupType) {
        canvas.addElement(MarkupTextBlock(markupType: markupType))
    }
}
