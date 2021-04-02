import SwiftUI

struct SideMenuView: View {
    @Binding var canvasName: String

    // TODO: replace these with actual linked and unlinked canvases
    @State var linkedCanvases: [String] = (1...100).map({ "Canvas: \($0)" })
    @State var selectedLinkedCanvases: [String] = []

    @State var unlinkedCanvases: [String] = (200...300).map({ "Canvas: \($0)" })
    @State var selectedUnlinkedCanvases: [String] = []

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
                MultiSelectCanvasListView(items: $linkedCanvases, selections: $selectedLinkedCanvases)
            }
            upDownButtons
            SideMenuContentView(label: "Unlinked Canvases") {
                MultiSelectCanvasListView(items: $unlinkedCanvases, selections: $selectedUnlinkedCanvases)
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
            .disabled(selectedUnlinkedCanvases.isEmpty)
            Button(action: {
                unlinkSelectedLinkedCanvases()
            }) {
                Image(systemName: "arrow.down.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            .disabled(selectedLinkedCanvases.isEmpty)
            Spacer()
        }
    }
}

// MARK: Linking and unlinking of canvases
extension SideMenuView {
    // TODO: replace these with actual implementations
    private func linkSelectedUnlinkedCanvases() {
        linkedCanvases.append(contentsOf: selectedUnlinkedCanvases)
        unlinkedCanvases = unlinkedCanvases.filter {
            !selectedUnlinkedCanvases.contains($0)
        }
        selectedUnlinkedCanvases = []
        linkedCanvases.sort()
    }

    private func unlinkSelectedLinkedCanvases() {
        unlinkedCanvases.append(contentsOf: selectedLinkedCanvases)
        linkedCanvases = linkedCanvases.filter {
            !selectedLinkedCanvases.contains($0)
        }
        selectedLinkedCanvases = []
        unlinkedCanvases.sort()
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
    }
}
