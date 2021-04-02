import SwiftUI

struct MultiSelectCanvasListView: View {
    // TODO: replace these with actual canvases
    @Binding var items: [String]
    @Binding var selections: [String]

    var body: some View {
        List {
            ForEach(self.items, id: \.self) { item in
                MultiSelectCanvasListRowView(name: item, isSelected: self.selections.contains(item)) {
                    if self.selections.contains(item) {
                        self.selections.removeAll(where: { $0 == item })
                    } else {
                        self.selections.append(item)
                    }
                }
            }
        }
    }
}

private struct MultiSelectCanvasListRowView: View {
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
