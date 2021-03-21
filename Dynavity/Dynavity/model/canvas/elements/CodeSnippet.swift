import CoreGraphics
import Foundation

struct CodeSnippet: CanvasElementProtocol {
    var textBlock = TextBlock()
    var language = CodeLanguage.python

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
}
