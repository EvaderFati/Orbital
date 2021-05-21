//
//  GroupView.swift
//  Orbital
//
//  Created by Evader on 19/5/21.
//  Refered to SwiftUI Kit by Jordan Singer
//

import SwiftUI

struct GroupView<Content: View>: View {
    var title: String
    let content: () -> Content
    
    var body: some View {
        return List {
            content()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(title, displayMode: .inline)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(title: "Group", content: { Text("Content") })
            .previewLayout(.sizeThatFits)
    }
}
