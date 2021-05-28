//
//  ContentView.swift
//  Orbital
//
//  Created by Evader on 11/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                BrowseView()
                    .tabItem {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 22))
                        Text("Browse")
                            .font(.system(size: 10))
                    }
                    .tag(0)
                Text("")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 22, weight: .semibold))
                        Text("Search")
                            .font(.system(size: 10))
                    }
                    .tag(1)
                Text("")
                    .tabItem {
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                        Text("User")
                            .font(.system(size: 10))
                    }
                    .tag(2)
            }
            .navigationTitle(selection == 0
                ? "Browse"
                : selection == 1
                    ? "Search"
                    : "User")
        }
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
