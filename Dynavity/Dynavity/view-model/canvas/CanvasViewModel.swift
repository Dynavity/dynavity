//
//  CanvasViewModel.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI
import PencilKit

class CanvasViewModel: ObservableObject {
    @Published var canvas = Canvas()
    @Published var annotationCanvas = AnnotationCanvas()
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

    func storeAnnotation(_ drawing: PKDrawing) {
        var annotationCanvas = AnnotationCanvas()
        annotationCanvas.drawing = drawing
    }
}
