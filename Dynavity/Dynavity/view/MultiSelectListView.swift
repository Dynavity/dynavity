import SwiftUI

struct MultiSelectListView: View {
    var nodes: [BacklinkNode]
    @Binding var selections: [BacklinkNode]

    var body: some View {
        List {
            ForEach(self.nodes, id: \.self) { node in
                MultiSelectListRowView(name: node.name, isSelected: self.selections.contains(node)) {
                    if self.selections.contains(node) {
                        self.selections.removeAll(where: { $0 == node })
                    } else {
                        self.selections.append(node)
                    }
                }
            }
        }
    }
}

private struct MultiSelectListRowView: View {
    var name: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.name)

                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
