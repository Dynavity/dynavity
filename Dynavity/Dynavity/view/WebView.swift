import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let bodyHtmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        // iPhone X/XS iOS 12
        view.customUserAgent = """
            Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) \
            Version/12.0 Mobile/15A372 Safari/604.1
        """
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let rawHtml = """
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    :root {
                        word-wrap: break-word;
                    }
                </style>
            </head>

            <body>
            \(bodyHtmlContent)
            </body>
        """
        uiView.loadHTMLString(rawHtml, baseURL: nil)
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(bodyHtmlContent: "<p>Hello!</p><ul><li>Cool html</li><li>More cool html</li></ul>")
    }
}
