//
//  ContentView.swift
//  Orbital
//
//  Created by Evader on 11/5/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("")
    }
}

struct Grouping<Content: View>: View {
    var title: String
    var icon: String
    var content: () -> Content
    
    var body: some View {
        NavigationLink(destination: GroupView(title: title, content: content)) {
            #if os(iOS)
            Label(title, systemImage: icon).font(.headline).padding(.vertical, 8)
            #else
            Label(title, systemImage: icon)
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
