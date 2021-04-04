import CoreGraphics
import Foundation

struct CodeElement: TextElementProtocol {
    // MARK: CanvasElementProtocol
    var id = UUID()
    var position: CGPoint
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero
    var minimumWidth: CGFloat {
        60.0
    }
    var minimumHeight: CGFloat {
        60.0
    }
    var observers = [ElementChangeListener]()

    // MARK: TextElementProtocol
    var text: String = ""

    // MARK: CodeElement-specific attributes
    var language = CodeLanguage.python

    init(position: CGPoint) {
        self.position = position
        resetCodeTemplate()
    }

    enum CodeLanguage: Int, CaseIterable, Identifiable, Codable {
        case python, java, c, javascript

        var id: Int {
            self.rawValue
        }

        var backendName: String {
            switch self {
            case .python:
                return "python"
            case .java:
                return "java"
            case .c:
                return "c"
            case .javascript:
                return "javascript"
            }
        }

        var displayName: String {
            switch self {
            case .python:
                return "Python"
            case .java:
                return "Java"
            case .c:
                return "C"
            case .javascript:
                return "Javascript"
            }
        }

        var template: String {
            switch self {
            case .python:
                return "# Your program here\n"
            case .java:
                return """
                    public class Program {
                        public static void main(String[] args) {
                            // Your program here
                        }
                    }
                    """
            case .c:
                return """
                    #include <stdio.h>
                    #include <stdlib.h>

                    int main(void) {
                        // Your program here
                        return 0;
                    }
                    """
            case .javascript:
                return "// Your program here\n"
            }
        }
    }

    mutating func resetCodeTemplate() {
        self.text = language.template
    }

    mutating func convertQuotes() {
        let charsToReplace = [
            ("\u{201c}", "\""),
            ("\u{201d}", "\""),
            ("\u{2018}", "'"),
            ("\u{2019}", "'")
        ]
        var processed = self.text
        charsToReplace.forEach {
            processed = processed.replacingOccurrences(of: $0.0, with: $0.1)
        }
        self.text = processed
    }
}

extension CodeElement: Codable {
    private enum CodingKeys: CodingKey {
        case id, position, width, height, rotation, text, language
    }
}
