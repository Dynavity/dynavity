import Combine
import CoreGraphics
import Foundation

class CodeElement: PlainTextElement {
    var language: CodeLanguage {
        didSet {
            resetCodeTemplate()
        }
    }

    override init(position: CGPoint) {
        self.language = CodeLanguage.python
        super.init(position: position)
        resetCodeTemplate()
    }

    enum CodeLanguage: String, CaseIterable, Identifiable {
        case python, java, c, javascript

        var id: String {
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

    func resetCodeTemplate() {
        self.text = language.template
    }

    func convertQuotes() {
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
