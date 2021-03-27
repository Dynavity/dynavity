import SwiftUI

struct UmlSideMenuView: View {
    @ObservedObject var viewModel: CanvasViewModel
    private let umlCloseButtonOffset: CGFloat = -12.0

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
        Rectangle()
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                SideMenuHeaderView(headerText: "UML Shapes")
                SideMenuContentView(label: "Class Diagram",
                                    content: umlContent)
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
