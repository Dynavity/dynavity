import SwiftUI

struct MarkupView: View {
    @ObservedObject var viewModel = MarkupViewModel()

    // TODO: This is set to "selected" for now.
    // The parent view containing this view should probably implement the logic for view selection.
    // Purpose of having this state is because when the view is not selected, the text editor should not show
    // (except for when it's displaying plain text)
    @State var isViewSelected: Bool = true

    var body: some View {
        VStack {
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

            HStack {
                Spacer()
                ForEach(MarkupTextBlock.MarkupType.allCases, id: \.self) { markupType in
                    let opacity = markupType == viewModel.markupTextBlock.markupType ? 1.0 : 0.5

                    Button(markupType.displayName) {
                        viewModel.markupTextBlock.markupType = markupType
                    }.padding(.horizontal)
                    .opacity(opacity)
                }
            }.background(Color.gray.opacity(0.5))
        }
        .addCardOverlay()
        .padding()
    }
}

struct MarkupView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupView()
    }
}
