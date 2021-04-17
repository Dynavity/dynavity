import SwiftUI

struct UmlSideMenuView: View {
    @ObservedObject var viewModel: CanvasViewModel
    private let viewFactory = UmlElementViewFactory()
    private let umlCloseButtonOffset: CGFloat = -12.0
    private let shapePreviewSize: CGFloat = 80.0

    private let umlElements: [UmlElementProtocol] = [ActivityUmlElement(position: .zero, shape: .diamond),
                                                     ActivityUmlElement(position: .zero, shape: .rectangle)]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var closeMenuButton: some View {
        Button(action: {
            viewModel.hideUmlMenu()
        }) {
            Image(systemName: "arrow.left.square").resizable()
        }
        .frame(width: MainView.umlMenuButtonWidth, height: MainView.umlMenuButtonHeight)
        .offset(x: umlCloseButtonOffset, y: 0)
    }

    var umlContent: some View {
        LazyVGrid(columns: columns, spacing: 200) {
            ForEach(self.umlElements.map({ AnyUmlElementProtocol(umlElement: $0) })) { umlElementWrapper in
                let umlElement = umlElementWrapper.umlElement
                Button(action: {
                    viewModel.addUmlElement(umlElement: umlElement)
                }) {
                    viewFactory.createView(element: umlElement)
                }
                .frame(width: shapePreviewSize, height: shapePreviewSize)
            }
        }
        .padding(.horizontal)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                SideMenuHeaderView(headerText: "UML Shapes")
                SideMenuContentView(label: "Activity Diagram") {
                    umlContent
                }
                Divider()

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.UI.background)

            closeMenuButton.zIndex(-1)
        }
    }
}

struct UmlSideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        UmlSideMenuView(viewModel: CanvasViewModel())
    }
}
