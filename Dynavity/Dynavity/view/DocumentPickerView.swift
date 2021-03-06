import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController

    let onFileSelected: (URL) -> Void
    let contentTypes: [UTType]
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let documentPicker = UIViewControllerType(forOpeningContentTypes: contentTypes, asCopy: true)
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Do nothing.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Acts as a bridge between the UIDocumentPickerController's delegate and SwiftUI.
    final class Coordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        let parent: DocumentPickerView

        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }

        func documentPicker(
            _ picker: UIViewControllerType,
            didPickDocumentsAt urls: [URL]
        ) {
            guard let file = urls.first else {
                return
            }

            parent.onFileSelected(file)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
