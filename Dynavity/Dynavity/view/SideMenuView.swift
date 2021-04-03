import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var graphMapViewModel: GraphMapViewModel

    @Binding var canvasName: String

    // TODO: refactor this and listview to not directly interfact with model
    @State var selectedLinkedNodes: [BacklinkNode] = []
    @State var selectedUnlinkedNodes: [BacklinkNode] = []

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
                TextField("Enter Canvas Name", text: $canvasName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }

    var backlinksView: some View {
        Group {
            SideMenuHeaderView(headerText: "Backlinks")
            SideMenuContentView(label: "Linked Canvases") {
                MultiSelectListView(nodes: graphMapViewModel.getLinkedNodes(for: testId),
                                    selections: $selectedLinkedNodes)
            }
            upDownButtons
            SideMenuContentView(label: "Unlinked Canvases") {
                MultiSelectListView(nodes: graphMapViewModel.getUnlinkedNodes(for: testId),
                                    selections: $selectedUnlinkedNodes)
            }
        }
    }

    var upDownButtons: some View {
        HStack {
            Spacer()
            Button(action: {
                // TODO: create backlinks, update state (which should be computed from the array subtraction)
                linkSelectedUnlinkedCanvases()
            }) {
                Image(systemName: "arrow.up.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            .disabled(selectedUnlinkedNodes.isEmpty)
            Button(action: {
                unlinkSelectedLinkedCanvases()
            }) {
                Image(systemName: "arrow.down.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            .disabled(selectedLinkedNodes.isEmpty)
            Spacer()
        }
    }
}

// MARK: Linking and unlinking of canvases
extension SideMenuView {
    // TODO: replace these with actual implementations
    private func linkSelectedUnlinkedCanvases() {
        for unlinkedNode in selectedUnlinkedNodes {
            graphMapViewModel.addLinkBetween(testId, and: unlinkedNode.id)
        }
        selectedUnlinkedNodes = []
    }

    private func unlinkSelectedLinkedCanvases() {
        for linkedNode in selectedLinkedNodes {
            graphMapViewModel.removeLinkBetween(testId, and: linkedNode.id)
        }
        selectedLinkedNodes = []
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
        SideMenuView(canvasName: .constant("Cool Name"))
            .environmentObject(GraphMapViewModel())
    }
}
