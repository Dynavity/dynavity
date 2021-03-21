import CoreGraphics
import Foundation

struct CodeSnippet: CanvasElementProtocol {
    var textBlock = TextBlock()
    var language = CodeLanguage.python

    init() {
        resetCodeTemplate()
    }

    enum CodeLanguage: Int, CaseIterable, Identifiable {
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

    var id: UUID {
        textBlock.id
    }

    var position: CGPoint {
        get {
            textBlock.position
        }
        set {
            textBlock.position = newValue
        }
    }

    var programString: String {
        get {
            textBlock.text
        }
        set {
            textBlock.text = newValue
        }
    }

    var fontSize: CGFloat {
        textBlock.fontSize
    }

    mutating func resetCodeTemplate() {
        textBlock.text = language.template
    }
}
