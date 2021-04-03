import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var graphMapViewModel: GraphMapViewModel

    @Binding var canvasName: String

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
                                    selections: $sideMenuViewModel.selectedLinkedNodes)
            }
            upDownButtons
            SideMenuContentView(label: "Unlinked Canvases") {
                MultiSelectListView(nodes: graphMapViewModel.getUnlinkedNodes(for: testId),
                                    selections: $sideMenuViewModel.selectedUnlinkedNodes)
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
    // TODO: replace these with actual implementations
    private func linkSelectedUnlinkedCanvases() {
        for unlinkedNode in sideMenuViewModel.selectedUnlinkedNodes {
            graphMapViewModel.addLinkBetween(testId, and: unlinkedNode.id)
        }
        sideMenuViewModel.selectedUnlinkedNodes = []
    }

    private func unlinkSelectedLinkedCanvases() {
        for linkedNode in sideMenuViewModel.selectedLinkedNodes {
            graphMapViewModel.removeLinkBetween(testId, and: linkedNode.id)
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
        SideMenuView(canvasName: .constant("Cool Name"))
            .environmentObject(GraphMapViewModel())
    }
}
