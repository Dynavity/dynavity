//
//  CanvasViewModel.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

class CanvasViewModel: ObservableObject {
    @Published var canvas: Canvas
    @Published var selectedCanvasElementId: UUID?
    @Published var selectedImage: UIImage?

    init(canvas: Canvas) {
        self.canvas = canvas
    }

    convenience init() {
        self.init(canvas: Canvas())
    }

    func select(canvasElement: CanvasElementProtocol) {
        if selectedCanvasElementId == canvasElement.id {
            selectedCanvasElementId = nil
            return
        }
        selectedCanvasElementId = canvasElement.id
    }

    func unselectCanvasElement() {
        selectedCanvasElementId = nil
    }

    func moveSelectedCanvasElement(to location: CGPoint) {
        canvas.repositionCanvasElement(id: selectedCanvasElementId, to: location)
    }

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

    func addMarkUpTextBlock(markupType: MarkupTextBlock.MarkupType) {
        canvas.addElement(MarkupTextBlock(markupType: markupType))
    }
}
