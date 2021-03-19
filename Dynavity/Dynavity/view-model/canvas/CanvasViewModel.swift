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

    func addTextBlock() {
        canvas.addElement(TextBlock())
    }

    func addCodeSnippet() {
        canvas.addElement(CodeSnippet())
    }

    func addMarkUpTextBlock(markupType: MarkupTextBlock.MarkupType) {
        canvas.addElement(MarkupTextBlock(markupType: markupType))
    }
}
