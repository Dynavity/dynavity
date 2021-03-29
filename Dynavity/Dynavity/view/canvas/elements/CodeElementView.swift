import SwiftUI

struct CodeElementView: View {
    @StateObject var viewModel: CodeElementViewModel

    init(codeSnippet: CodeElement) {
        self._viewModel = StateObject(wrappedValue: CodeElementViewModel(codeSnippet: codeSnippet))
    }

    var body: some View {
        HStack {
            VStack {
                TextEditor(text: $viewModel.codeSnippet.text)
                    .font(.custom("Courier", size: viewModel.codeSnippet.fontSize))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: viewModel.codeSnippet.text) {_ in
                        viewModel.convertQuotes()
                    }
                Divider()
                HStack {
                    Picker("Language", selection: $viewModel.codeSnippet.language) {
                        ForEach(CodeElement.CodeLanguage.allCases) {
                            Text($0.displayName).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: viewModel.codeSnippet.language) {_ in
                        viewModel.resetCodeTemplate()
                    }
                    Button(action: viewModel.runCode, label: {
                        Text("Run")
                    })
                    .frame(maxWidth: .infinity)
                }
            }
            Divider()
            ScrollView {
                Text(viewModel.output)
            }
        }
        .padding()
    }
}

struct CodeElementView_Previews: PreviewProvider {
    static var previews: some View {
        CodeElementView(codeSnippet: CodeElement(position: .zero))
    }
}
