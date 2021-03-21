import CoreGraphics
import Foundation

struct CodeSnippet: CanvasElementProtocol {
    var textBlock: TextBlock
    var language = CodeLanguage.python

    init(position: CGPoint) {
        self.textBlock = TextBlock(position: position)
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

    var width: CGFloat {
        get {
            textBlock.width
        }
        set {
            textBlock.width = newValue
        }
    }

    var height: CGFloat {
        get {
            textBlock.height
        }
        set {
            textBlock.height = newValue
        }
    }

    var rotation: Double {
        get {
            textBlock.rotation
        }
        set {
            textBlock.rotation = newValue
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

    mutating func convertQuotes() {
        let charsToReplace = [
            ("\u{201c}", "\""),
            ("\u{201d}", "\""),
            ("\u{2018}", "'"),
            ("\u{2019}", "'")
        ]
        var processed = textBlock.text
        charsToReplace.forEach {
            processed = processed.replacingOccurrences(of: $0.0, with: $0.1)
        }
        textBlock.text = processed
    }
}
