import SwiftUI

struct CodeSnippetView: View {
    @ObservedObject var viewModel: CodeSnippetViewModel

    init(codeSnippet: CodeSnippet) {
        self.viewModel = CodeSnippetViewModel(codeSnippet: codeSnippet)
    }

    var body: some View {
        HStack {
            VStack {
                TextEditor(text: $viewModel.codeSnippet.programString)
                Divider()
                HStack {
                    Button(action: viewModel.runCode, label: {
                        Text("Run")
                    })
                }
            }

            Divider()
            Text(viewModel.output)
        }
        .padding()
    }
}

struct CodeSnippetView_Previews: PreviewProvider {
    static var previews: some View {
        CodeSnippetView(codeSnippet: CodeSnippet())
    }
}
