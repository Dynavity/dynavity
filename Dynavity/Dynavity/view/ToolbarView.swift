import SwiftUI

struct ToolbarView: View {
    private enum ActiveSheet: Identifiable {
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
                activeSheet = .pdfPicker
            }) {
                Label("PDF", systemImage: "doc.text")
            }
            /*
            Button(action: {
                // TODO: Implement to-do list card.
            }) {
                Label("To-Do List", systemImage: "list.bullet.rectangle")
            }
            */
            Button(action: {
                viewModel.addTextBlock()
            }) {
                Label("Text", systemImage: "note.text")
            }
            Button(action: {
                viewModel.addCodeSnippet()
            }) {
                Label("Code", systemImage: "chevron.left.slash.chevron.right")
            }
            markupTextBlockButtons
        }
        label: {
            Label("Add", systemImage: "plus")
        }
    }

    private var markupTextBlockButtons: some View {
        Group {
            Button(action: {
                viewModel.addMarkUpTextBlock(markupType: .markdown)
            }) {
                Label("Markdown", systemImage: "text.badge.star")
            }
            Button(action: {
                viewModel.addMarkUpTextBlock(markupType: .latex)
            }) {
                Label("LaTeX", systemImage: "doc.richtext")
            }
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
        .sheet(item: $activeSheet) { item in
            switch item {
            case .camera:
                ImagePickerView(onImageSelected: viewModel.addImageCanvasElement, sourceType: .camera)
            case .photoGallery:
                ImagePickerView(onImageSelected: viewModel.addImageCanvasElement, sourceType: .photoLibrary)
            case .pdfPicker:
                DocumentPickerView(onFileSelected: viewModel.addPdfCanvasElement, contentTypes: [.pdf])
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
