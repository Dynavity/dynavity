//
//  ToolbarView.swift
//  Dynavity
//
//  Created by Ian Yong on 17/3/21.
//

import SwiftUI

struct ToolbarView: View {
    private let height: CGFloat = 40.0
    private let padding: CGFloat = 8.0

    private var addButton: some View {
        Button(action: {
            // TODO: Implement card types.
        }) {
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(padding)
        }
    }

    var body: some View {
        HStack {
            Spacer()
            addButton
        }
        .frame(height: height)
        .padding(.leading, padding)
        .padding(.trailing, padding)
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
    }
}
