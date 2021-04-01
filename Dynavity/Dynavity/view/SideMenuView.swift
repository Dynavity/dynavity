import SwiftUI

struct SideMenuView: View {
    @Binding var canvasName: String

    var body: some View {
        VStack(alignment: .leading) {
            SideMenuHeaderView(headerText: "Canvas Metadata")
            SideMenuContentView(label: "Canvas Name") {
                TextField("Enter Canvas Name", text: $canvasName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Divider()

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.UI.background)
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
