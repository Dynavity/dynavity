import Combine
import Foundation

struct RunnableCodeExecutor: CodeExecutor {

    private static let endpoint = "wss://t8jfxu45v2.execute-api.us-east-2.amazonaws.com/production/"

    func getOutputPublisher(program: String, language: CodeElement.CodeLanguage) -> AnyPublisher<String, Never> {
        let connection = createNewConnection()
        let outputStream = PassthroughSubject<String, Never>()

        // initial launch command
        let launchBody = [
            "action": "launch",
            "mode": "compile",
            "lang": language.backendName,
            "prog": program
        ]
        guard let launchCommand = try? JSONSerialization
                .data(withJSONObject: launchBody, options: .prettyPrinted) else {
            fatalError("Problem serializing WebSocket data")
        }
        let cmd = String(data: launchCommand, encoding: .utf8)!
        connection.send(.string(cmd)) { _ in }

        // managing output
        var containerId = ""
        func handleMessage(containerId id: String?, output: String?) {
            guard let id = id else {
                // if there is no id, ignore
                return
            }
            if let output = output {
                // output exists
                guard id == containerId else {
                    // container does not match, ignore
                    return
                }
                // container matches, publish output
                outputStream.send(output)
            } else {
                // output does not exist
                // this is a response to the launch command
                containerId = id
            }
        }
        func listenForOutput() {
            connection.receive { response in
                guard let json = identifyJsonMessage(from: response) else {
                    // not in JSON format, ignore
                    return
                }
                handleMessage(containerId: json["containerId"], output: json["output"])
                // on successful JSON message, listen again
                listenForOutput()
            }
        }
        // initial call to start the recursion
        listenForOutput()

        return outputStream
            // on cancel, clean up the connection
            .handleEvents(receiveCancel: connection.cancel)
            // return an AnyPublisher
            .eraseToAnyPublisher()
    }

    private func createNewConnection() -> URLSessionWebSocketTask {
        guard let url = URL(string: RunnableCodeExecutor.endpoint) else {
            fatalError("Invalid URL")
        }
        let connection = URLSession.shared.webSocketTask(with: url)
        connection.resume()
        return connection
    }

    private func identifyJsonMessage(from response: Result<URLSessionWebSocketTask.Message, Error>)
    -> [String: String]? {
        // attempt to read it as a text string, as opposed to reading as binary data
        // this is due to limitations on the backend (does not work with binary data)
        guard let text = identifyTextMessage(from: response) else {
            return nil
        }
        // attempt to parse it into a [String:String] mapping
        return toJsonDict(text: text)
    }

    private func toJsonDict(text: String) -> [String: String]? {
        guard let data = text.data(using: .utf8),
              let jsonAny = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonDict = jsonAny as? [String: String] else {
            return nil
        }
        return jsonDict
    }

    private func identifyTextMessage(from response: Result<URLSessionWebSocketTask.Message, Error>) -> String? {
        switch response {
        case .failure:
            return nil
        case .success(let message):
            switch message {
            case .string(let text):
                return text
            case .data:
                return nil
            @unknown default:
                return nil
            }
        }
    }

}
