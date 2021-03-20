import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController

    let onImageSelected: (UIImage) -> Void
    var sourceType: UIViewControllerType.SourceType
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let imagePicker = UIViewControllerType()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Do nothing.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Acts as a bridge between the UIImagePickerController's delegate and SwiftUI.
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIViewControllerType,
            didFinishPickingMediaWithInfo info: [UIViewControllerType.InfoKey: Any]
        ) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }

            parent.onImageSelected(image)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
