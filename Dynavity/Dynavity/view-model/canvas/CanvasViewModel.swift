//
//  CanvasViewModel.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

class CanvasViewModel: ObservableObject {
    @Published var canvas: Canvas
    @Published var selectedCanvasElement: CanvasElementProtocol?
    @Published var selectedImage: UIImage?

    init(canvas: Canvas) {
        self.canvas = canvas
    }

    convenience init() {
        self.init(canvas: Canvas())
    }

    func select(canvasElement: CanvasElementProtocol) {
        if selectedCanvasElement?.id == canvasElement.id {
            selectedCanvasElement = nil
            return
        }
        selectedCanvasElement = canvasElement
    }

    func unselectCanvasElement() {
        selectedCanvasElement = nil
    }

    func moveSelectedCanvasElement(to location: CGPoint) {
        canvas.repositionCanvasElement(id: selectedCanvasElement?.id, to: location)
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
}
