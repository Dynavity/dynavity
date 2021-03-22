import SwiftUI

class CodeElementViewModel: ObservableObject {
    @Published var codeSnippet: CodeElement
    @Published var output: String = ""

    private var connection: URLSessionWebSocketTask
    private var containerId: String = ""

    init(codeSnippet: CodeElement) {
        self.codeSnippet = codeSnippet

        let endpointUrl = "wss://t8jfxu45v2.execute-api.us-east-2.amazonaws.com/production/"
        guard let url = URL(string: endpointUrl) else {
            fatalError("Endpoint URL is an invalid constant")
        }
        let connection = URLSession(configuration: .default).webSocketTask(with: url)
        self.connection = connection
    }

    func runCode() {
        let program = codeSnippet.programString
        guard !program.isEmpty else {
            // backend will not accept an empty program
            return
        }
        connection.resume()
        clearOutput()
        let launchBody = [
            "action": "launch",
            "mode": "compile",
            "lang": codeSnippet.language.backendName,
            "prog": program
        ]

        guard let launchCommand = try? JSONSerialization
                .data(withJSONObject: launchBody, options: .prettyPrinted) else {
            // problem serializing data
            return
        }
        let cmd = String(data: launchCommand, encoding: .utf8)!
        connection.send(.string(cmd)) { _ in }
        listenForOutput()
    }

    func listenForOutput() {
        func processTextResponse(text: String) {
            guard let data = text.data(using: .utf8),
                  let jsonAny = try? JSONSerialization.jsonObject(with: data, options: []),
                  let jsonDict = jsonAny as? [String: String],
                  let container = jsonDict["containerId"] else {
                return
            }
            if let output = jsonDict["output"] {
                guard container == self.containerId else {
                    // ignore output from a different container
                    return
                }
                DispatchQueue.main.async {
                    self.addOutput(line: output)
                }
            } else {
                // response from container
                self.containerId = container
            }
        }

        func identifyMessage(response: Result<URLSessionWebSocketTask.Message, Error>) {
            switch response {
            case .failure(let error):
                print(error)
            case .success(let message):
                switch message {
                case .string(let text):
                    print(text)
                    processTextResponse(text: text)
                case .data(let data):
                    print(data)
                @unknown default:
                    fatalError("Unknown message type")
                }
                // continue listening for output only on success
                self.listenForOutput()
            }
        }
        connection.receive(completionHandler: identifyMessage)
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
