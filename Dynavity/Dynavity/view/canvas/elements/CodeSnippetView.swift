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
                    .font(.custom("Courier", size: viewModel.codeSnippet.fontSize))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Divider()
                HStack {
                    Picker("Language", selection: $viewModel.codeSnippet.language) {
                        let languages = CodeSnippet.CodeLanguage.allCases
                        ForEach(0 ..< languages.count) {
                            Text(languages[$0].displayName)
                        }
                    }
                    Button(action: viewModel.runCode, label: {
                        Text("Run")
                    })
                    .frame(maxWidth: .infinity)
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
