import Combine

protocol CodeExecutor {
    func getOutputPublisher(program: String, language: CodeElement.CodeLanguage) -> AnyPublisher<String, Never>
}
