import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController

    @State private var url: URL?
    let contentTypes: [UTType]
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let documentPicker = UIViewControllerType(forOpeningContentTypes: contentTypes, asCopy: true)
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

        func documentPickerController(
            _ picker: UIViewControllerType,
            didPickDocumentsAt urls: [URL]
        ) {
            parent.url = urls[0]
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
