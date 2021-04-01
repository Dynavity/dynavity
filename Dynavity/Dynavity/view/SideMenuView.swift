import SwiftUI

struct SideMenuView: View {
    @Binding var canvasName: String

    // TODO: replace these with actual linked and unlinked canvases
    var linkedCanvases: [String] = (1...100).map({ "Canvas: \($0)" })
    var unlinkedCanvases: [String] = (200...300).map({ "Canvas: \($0)" })

    var body: some View {
        VStack(alignment: .leading) {
            canvasMetadataView
            Divider().padding(.vertical)
            linkedCanvasesView
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

    var linkedCanvasesView: some View {
        Group {
            SideMenuHeaderView(headerText: "Backlinks")
            SideMenuContentView(label: "Linked Canvases") {
                List(linkedCanvases, id: \.self) { canvas in
                    Text(canvas)
                }
                .listStyle(SidebarListStyle())
            }

            upDownButtons

            SideMenuContentView(label: "Unlinked Canvases") {
                List(unlinkedCanvases, id: \.self) { canvas in
                    Text(canvas)
                }
                .listStyle(SidebarListStyle())
            }
        }
    }

    var upDownButtons: some View {
        HStack {
            Spacer()
            Button(action: {
                print("UP!")
            }) {
                Image(systemName: "arrow.up.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            Button(action: {
                print("DOWN!")
            }) {
                Image(systemName: "arrow.down.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            Spacer()
        }

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
