//
//  TextBlockView.swift
//  Dynavity
//
//  Created by Sebastian on 17/3/21.
//

import SwiftUI

struct TextBlockView: View {
    @ObservedObject var viewModel = TextBlockViewModel()

    var body: some View {
        TextEditor(text: $viewModel.textBlock.text)
            .font(.custom("Custom", size: viewModel.textBlock.fontSize))
            .padding()
    }
}

struct TextBlockView_Previews: PreviewProvider {
    static var previews: some View {
        TextBlockView()
    }
}
