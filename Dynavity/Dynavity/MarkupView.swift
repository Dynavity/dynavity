//
//  MarkupView.swift
//  Dynavity
//
//  Created by Sebastian on 14/3/21.
//

import SwiftUI

struct MarkupView: View {
    @ObservedObject var viewModel = MarkupViewModel()

    var body: some View {
        HStack {
            TextEditor(text: $viewModel.markupTextBlock.rawText)
            WebView(rawHtml: viewModel.markupTextBlock.toHtml())
        }
    }
}

struct MarkupView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupView()
    }
}
