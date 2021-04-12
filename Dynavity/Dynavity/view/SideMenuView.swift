import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var graphMapViewModel: GraphMapViewModel

    var canvasName: String

    @StateObject private var sideMenuViewModel = SideMenuViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            canvasMetadataView
            Divider().padding(.vertical)
            backlinksView
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.UI.background)
    }

    var canvasMetadataView: some View {
        Group {
            SideMenuHeaderView(headerText: "Canvas Metadata")
            SideMenuContentView(label: "Canvas Name") {
                Text(canvasName)
                    .bold()
            }
        }
    }

    var backlinksView: some View {
        Group {
            SideMenuHeaderView(headerText: "Backlinks")
            SideMenuContentView(label: "Linked Canvases") {
                MultiSelectListView(nodes: graphMapViewModel.getLinkedNodes(for: canvasName),
                                    selections: $sideMenuViewModel.selectedLinkedNodes)
            }
            upDownButtons
            SideMenuContentView(label: "Unlinked Canvases") {
                MultiSelectListView(nodes: graphMapViewModel.getUnlinkedNodes(for: canvasName),
                                    selections: $sideMenuViewModel.selectedUnlinkedNodes)
            }
        }
    }

    var upDownButtons: some View {
        HStack {
            Spacer()
            Button(action: {
                linkSelectedUnlinkedCanvases()
            }) {
                Image(systemName: "arrow.up.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            .disabled(sideMenuViewModel.selectedUnlinkedNodes.isEmpty)
            Button(action: {
                unlinkSelectedLinkedCanvases()
            }) {
                Image(systemName: "arrow.down.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            .disabled(sideMenuViewModel.selectedLinkedNodes.isEmpty)
            Spacer()
        }
    }
}

// MARK: Linking and unlinking of canvases
extension SideMenuView {
    private func linkSelectedUnlinkedCanvases() {
        for unlinkedNode in sideMenuViewModel.selectedUnlinkedNodes {
            graphMapViewModel.addLinkBetween(canvasName, and: unlinkedNode.name)
        }
        sideMenuViewModel.selectedUnlinkedNodes = []
    }

    private func unlinkSelectedLinkedCanvases() {
        for linkedNode in sideMenuViewModel.selectedLinkedNodes {
            graphMapViewModel.removeLinkBetween(canvasName, and: linkedNode.name)
        }
        sideMenuViewModel.selectedLinkedNodes = []
    }
}

struct SideMenuHeaderView: View {
    var headerText: String

    var body: some View {
        Text(headerText)
            .font(.title3)
            .bold()
            .padding(.bottom)
    }
}

struct SideMenuContentView<Content: View>: View {
    let label: String
    let content: Content

    init(label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .fixedSize()
            content
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(canvasName: "Cool Name")
            .environmentObject(GraphMapViewModel())
    }
}
