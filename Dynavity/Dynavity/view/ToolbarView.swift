import SwiftUI
import PencilKit

struct ToolbarView: View {
    private enum ActiveSheet: Identifiable {
        case camera
        case photoGallery
        case pdfPicker

        var id: Int {
            hashValue
        }
    }

    private enum SelectedAnnotationTool: Identifiable {
        case pen
        case marker
        case eraser
        case lasso

        var id: Int {
            hashValue
        }
    }

    private let height: CGFloat = 25.0
    private let padding: CGFloat = 10.0
    private let toolButtonSize: CGFloat = 25.0
    private let selectorSize: CGFloat = 40.0

    @ObservedObject var viewModel: CanvasViewModel
    @State private var activeSheet: ActiveSheet?
    @Binding var shouldShowSideMenu: Bool
    @State private var shouldShowAnnotationMenu = false
    @State private var currentlySelectedTool = SelectedAnnotationTool.pen

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

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

    private var annotationMenu: some View {
        HStack {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.getAnnotationWidths(), id: \.self) { width in
                    Button(action: {
                        viewModel.switchAnnotationWidth(width)
                        shouldShowAnnotationMenu = false
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                            Circle()
                                .fill(Color.white)
                                .frame(width: width, height: width, alignment: .center)
                        }
                    }.frame(width: selectorSize, height: selectorSize)
                }
            }
            Spacer()
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.getAnnotationColors(), id: \.self) { color in
                    Button(action: {
                        viewModel.switchAnnotationColor(color)
                        shouldShowAnnotationMenu = false
                    }) {
                        Circle().fill(Color(color))
                    }.frame(width: selectorSize, height: selectorSize)
                }
            }
        }
        .offset(x: 0, y: 80)
        .frame(width: 200, height: 100, alignment: .center)
    }

    private var penSelectionButton: some View {
        Button(action: {
            if currentlySelectedTool == .pen {
                shouldShowAnnotationMenu = true
            }
            currentlySelectedTool = .pen
            viewModel.switchAnnotationTool(viewModel.getDefaultAnnotationTool(PKInkingTool.InkType.pen))

        }) {
            Image(systemName: "pencil")
                .resizable()
                .frame(width: toolButtonSize, height: toolButtonSize, alignment: .center)
        }
        .background(currentlySelectedTool == SelectedAnnotationTool.pen
                        ? Color.UI.grey
                        : nil)
        .overlay(shouldShowAnnotationMenu &&
                    currentlySelectedTool == SelectedAnnotationTool.pen
                    ? annotationMenu
                    : nil)
    }

    private var markerSelectionButton: some View {
        Button(action: {
            if currentlySelectedTool == .marker {
                shouldShowAnnotationMenu = true
            }
            currentlySelectedTool = .marker
            viewModel.switchAnnotationTool(viewModel.getDefaultAnnotationTool(PKInkingTool.InkType.marker))
        }) {
            Image(systemName: "highlighter")
                .resizable()
                .frame(width: toolButtonSize, height: toolButtonSize, alignment: .center)
        }
        .background(currentlySelectedTool == SelectedAnnotationTool.marker ? Color.UI.grey : nil)
        .overlay(shouldShowAnnotationMenu &&
                    currentlySelectedTool == SelectedAnnotationTool.marker
                    ? annotationMenu
                    : nil)
    }

    private var eraserSelectionButton: some View {
        Button(action: {
            currentlySelectedTool = .eraser
            viewModel.switchAnnotationTool(PKEraserTool(.vector))
        }) {
            Image(systemName: "rectangle.portrait")
                .resizable()
                .frame(width: toolButtonSize / 1.5, height: toolButtonSize, alignment: .center)
        }
        .background(currentlySelectedTool == SelectedAnnotationTool.eraser ? Color.UI.grey : nil)
    }

    private var lassoSelectionButton: some View {
        Button(action: {
            currentlySelectedTool = .lasso
            viewModel.switchAnnotationTool(PKLassoTool())
        }) {
            Image(systemName: "lasso")
                .resizable()
                .frame(width: toolButtonSize, height: toolButtonSize, alignment: .center)
        }
        .background(currentlySelectedTool == SelectedAnnotationTool.lasso ? Color.UI.grey : nil)
    }

    var body: some View {
        HStack {
            Spacer()
            penSelectionButton
            markerSelectionButton
            eraserSelectionButton
            lassoSelectionButton
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
