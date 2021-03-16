import SwiftUI

struct MarkupView: View {
    @ObservedObject var viewModel = MarkupViewModel()

    // TODO: This is set to "selected" for now.
    // The parent view containing this view should probably implement the logic for view selection.
    // Purpose of having this state is so that when the view is not selected, the text editor will not show
    // (except when it's displaying plain text)
    @State var isViewSelected: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            textEditorAndPreview
            statusLine
        }
        .addCardOverlay()
        .padding()
    }

    var textEditorAndPreview: some View {
        HStack {
            let isPlainText = viewModel.markupTextBlock.markupType == .plaintext

            if isViewSelected || isPlainText {
                TextEditor(text: $viewModel.markupTextBlock.text)
                    .font(.custom("Custom", size: viewModel.markupTextBlock.fontSize))
            }

            // Show divider only when TextEditor and WebView are both shown
            if isViewSelected && !isPlainText {
                Divider()
            }

            if !isPlainText {
                WebView(rawHtml: viewModel.rawHtml)
            }
        }
    }

    var statusLine: some View {
        HStack {
            Spacer()
            ForEach(MarkupTextBlock.MarkupType.allCases, id: \.self) { markupType in
                let opacity = markupType == viewModel.markupTextBlock.markupType ? 1.0 : 0.5

                Button(markupType.displayName) {
                    viewModel.markupTextBlock.markupType = markupType
                }.padding(.horizontal)
                .opacity(opacity)
                .foregroundColor(Color.UI.blue)
            }
        }.background(Color.UI.base2)
    }
}

struct MarkupView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupView()
    }
}
