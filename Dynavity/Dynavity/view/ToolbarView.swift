import SwiftUI

struct ToolbarView: View {
    private let height: CGFloat = 25.0
    private let padding: CGFloat = 10.0

    @State private var displayPhotoGallery = false

    private var addButton: some View {
        Menu {
            Button(action: {
                // TODO: Implement photo taking functionality.
            }) {
                Label("Camera", systemImage: "camera")
            }
            Button(action: {
                displayPhotoGallery.toggle()
            }) {
                Label("Photo Gallery", systemImage: "photo")
            }
            Button(action: {
                // TODO: Implement PDF import functionality.
            }) {
                Label("PDF", systemImage: "doc.text")
            }
            Button(action: {
                // TODO: Implement to-do list card.
            }) {
                Label("To-Do List", systemImage: "list.bullet.rectangle")
            }
            Button(action: {
                // TODO: Implement text card.
            }) {
                Label("Text", systemImage: "note.text")
            }
            Button(action: {
                // TODO: Implement code block card.
            }) {
                Label("Code", systemImage: "chevron.left.slash.chevron.right")
            }
            Button(action: {
                // TODO: Implement markup text card.
            }) {
                Label("Markup", systemImage: "text.badge.star")
            }
        }
        label: {
            Label("Add", systemImage: "plus")
        }
    }

    var body: some View {
        HStack {
            Spacer()
            addButton
        }
        .frame(height: height)
        .padding(padding)
        .background(
            Color(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.top)
        )
        // Force the toolbar to be drawn over everything else.
        .zIndex(.infinity)
        .sheet(isPresented: $displayPhotoGallery) {
            ImagePickerView()
        }
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
    }
}
