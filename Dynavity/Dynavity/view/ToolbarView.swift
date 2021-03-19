import SwiftUI

struct ToolbarView: View {
    enum ActiveSheet: Identifiable {
        case camera
        case photoGallery
        case pdfPicker

        var id: Int {
            hashValue
        }
    }

    private let height: CGFloat = 25.0
    private let padding: CGFloat = 10.0

    @ObservedObject var viewModel: CanvasViewModel
    @Binding var shouldShowSideMenu: Bool

    private var addButton: some View {
        Menu {
            Button(action: {
                viewModel.displayCamera()
            }) {
                Label("Camera", systemImage: "camera")
            }
            Button(action: {
                viewModel.displayPhotoGallery()
            }) {
                Label("Photo Gallery", systemImage: "photo")
            }
            Button(action: {
                viewModel.displayPdfPicker()
            }) {
                Label("PDF", systemImage: "doc.text")
            }
            Button(action: {
                // TODO: Implement to-do list card.
            }) {
                Label("To-Do List", systemImage: "list.bullet.rectangle")
            }
            Button(action: {
                viewModel.addTextBlock()
            }) {
                Label("Text", systemImage: "note.text")
            }
            Button(action: {
                // TODO: Implement code block card.
            }) {
                Label("Code", systemImage: "chevron.left.slash.chevron.right")
            }
            Button(action: {
                // TODO: Update this function to take in a markupType based on user input
                viewModel.addMarkUpTextBlock(markupType: .markdown)
            }) {
                Label("Markup", systemImage: "text.badge.star")
            }
        }
        label: {
            Label("Add", systemImage: "plus")
        }
    }

    private var sideMenuButton: some View {
        Button(action: {
            withAnimation {
                shouldShowSideMenu = true
            }
        }) {
            Image(systemName: "ellipsis")
        }
    }

    var body: some View {
        HStack {
            Spacer()
            addButton
            Spacer()
            sideMenuButton
        }
        .frame(height: height)
        .padding(padding)
        .background(
            Color(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.top)
        )
        .sheet(item: $viewModel.activeSheet, onDismiss: viewModel.handleSheetDismiss) { item in
            switch item {
            case .camera:
                ImagePickerView(selectedImage: $viewModel.selectedImage, sourceType: .camera)
            case .photoGallery:
                ImagePickerView(selectedImage: $viewModel.selectedImage, sourceType: .photoLibrary)
            case .pdfPicker:
                DocumentPickerView(selectedFile: $viewModel.selectedFile, contentTypes: [.pdf])
            }
        }
        // Force the toolbar to be drawn over everything else.
        .zIndex(.infinity)
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView(viewModel: CanvasViewModel(), shouldShowSideMenu: .constant(true))
    }
}
