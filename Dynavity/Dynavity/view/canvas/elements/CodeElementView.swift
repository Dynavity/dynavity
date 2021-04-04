import SwiftUI

struct CodeElementView: View {
    @StateObject var viewModel: CodeElementViewModel

    init(codeElement: CodeElement) {
        self._viewModel = StateObject(wrappedValue: CodeElementViewModel(codeElement: codeElement))
    }

    var body: some View {
        HStack {
            codeWindow
            Divider()
            outputWindow
        }
        .padding()
    }

    private var codeWindow: some View {
        VStack {
            TextEditor(text: $viewModel.codeElement.text)
                .font(.custom("Courier", size: viewModel.codeElement.fontSize))
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Divider()
            HStack {
                Picker("Language", selection: $viewModel.codeElement.language) {
                    ForEach(CodeElement.CodeLanguage.allCases) {
                        Text($0.displayName).tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: viewModel.codeElement.language) {_ in
                    viewModel.resetCodeTemplate()
                }
                Button(action: viewModel.runCode, label: {
                    Text("Run")
                })
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var outputWindow: some View {
        ScrollView {
            Text(viewModel.output)
        }
    }
}

struct CodeElementView_Previews: PreviewProvider {
    static var previews: some View {
        CodeElementView(codeElement: CodeElement(position: .zero))
    }
}
