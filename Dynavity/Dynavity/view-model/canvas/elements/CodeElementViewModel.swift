import SwiftUI
import Combine

class CodeElementViewModel: ObservableObject {
    @Published var codeSnippet: CodeElement
    @Published var output: String = ""

    // allows cancellation of the current execution (e.g. to make way for a new execution)
    private var currentExecution: AnyCancellable?

    init(codeSnippet: CodeElement) {
        self.codeSnippet = codeSnippet
    }

    func runCode() {
        let program = codeSnippet.text
        guard !program.isEmpty else {
            // backend will not accept an empty program
            return
        }
        clearOutput()
        if let previousExecution = currentExecution {
            previousExecution.cancel()
        }
        let executor: CodeExecutor = RunnableCodeExecutor()
        let outputStream = executor.getOutputPublisher(program: program, language: codeSnippet.language)
        currentExecution = outputStream.sink { output in
            DispatchQueue.main.async {
                self.addOutput(line: output)
            }
        }
    }

    func addOutput(line: String) {
        output.append(line + "\n")
    }

    func clearOutput() {
        output = ""
    }

    func resetCodeTemplate() {
        codeSnippet.resetCodeTemplate()
    }

    func convertQuotes() {
        codeSnippet.convertQuotes()
    }
}
