//
//  WebView.swift
//  Dynavity
//
//  Created by Sebastian on 14/3/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let rawHtml: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(rawHtml, baseURL: nil)
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(rawHtml: "<html><body><p>Hello!</p></body></html><ul><li>Cool html</li><li>More cool html</li></ul>")
    }
}
