import SwiftUI

struct ToolbarView: View {
    private enum ActiveSheet: Identifiable {
        case camera
        case photoGallery

        var id: Int {
            hashValue
        }
    }

    private let height: CGFloat = 25.0
    private let padding: CGFloat = 10.0

    @ObservedObject var viewModel: CanvasViewModel
    @State private var activeSheet: ActiveSheet?
    @Binding var shouldShowSideMenu: Bool

    private var addButton: some View {
        Menu {
            Button(action: {
                activeSheet = .camera
            }) {
                Label("Camera", systemImage: "camera")
            }
            Button(action: {
                activeSheet = .photoGallery
            }) {
                Label("Photo Gallery", systemImage: "photo")
            }
            Button(action: {
                // TODO: Implement PDF import functionality.
            }) {
                Label("PDF", systemImage: "doc.text")
            }
            Button(action: {
                // TODO: Implement to-do list card.
            }) {
                Label("To-Do List", systemImage: "list.bullet.rectangle")
            }
            Button(action: {
                // TODO: Implement text card.
            }) {
                Label("Text", systemImage: "note.text")
            }
            Button(action: {
                // TODO: Implement code block card.
            }) {
                Label("Code", systemImage: "chevron.left.slash.chevron.right")
            }
            Button(action: {
                // TODO: Implement markup text card.
            }) {
                Label("Markup", systemImage: "text.badge.star")
            }
        }
        label: {
            Label("Add", systemImage: "plus")
        }
    }

    var body: some View {

        HStack {
            Button(action: {
                withAnimation {
                    shouldShowSideMenu = true
                }
            }) {
                   Text("Show Menu")
            }
            Spacer()
            addButton
        }
        .frame(height: height)
        .padding(padding)
        .background(
            Color(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.top)
        )
        .sheet(item: $activeSheet, onDismiss: viewModel.addImageCanvasElement) { item in
            switch item {
            case .camera:
                ImagePickerView(selectedImage: $viewModel.selectedImage, sourceType: .camera)
            case .photoGallery:
                ImagePickerView(selectedImage: $viewModel.selectedImage, sourceType: .photoLibrary)
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
