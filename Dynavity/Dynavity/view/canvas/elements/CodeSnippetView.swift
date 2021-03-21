import SwiftUI

struct CodeSnippetView: View {
    @StateObject var viewModel: CodeSnippetViewModel

    init(codeSnippet: CodeSnippet) {
        self._viewModel = StateObject(wrappedValue: CodeSnippetViewModel(codeSnippet: codeSnippet))
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
                        ForEach(CodeSnippet.CodeLanguage.allCases) {
                            Text($0.displayName).tag($0)
                        }
                    }
                    .onChange(of: viewModel.codeSnippet.language) {_ in
                        viewModel.resetCodeTemplate()
                    }
                    .pickerStyle(SegmentedPickerStyle())
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
