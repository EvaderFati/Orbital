//
//  BrowseView.swift
//  Orbital
//
//  Created by Qianyi Wang on 2021/5/26.
//

import SwiftUI

struct BrowseView: View {
    @State private var locations: [Location] = Location.data
    
    var body: some View {
        VStack {
            SearchBar()
            List {
                Section(header: Text("Locations")
                            .font(.headline)
                            .foregroundColor(.black)) {
                    ForEach(locations) { location in
                        NavigationLink(
                            destination: LocationView(location: binding(for: location))) {
                            Label(location.name, systemImage: "folder")
                        }
                    }
                    NavigationLink(destination: Text("")) {
                        Label("Recently Deleted", systemImage: "trash")
                    }
                }
                .textCase(.none)
                Section(header: Text("Tags")
                            .font(.headline)
                            .foregroundColor(.black)) {
                    NavigationLink(destination: Text("")) {
                        Label("Stars", systemImage: "star")
                    }
                }
                .textCase(.none)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("Browse")
    }
    
    private func binding(for loc: Location) -> Binding<Location> {
        guard let locationIndex = locations.firstIndex(where: {$0.id == loc.id}) else {
            fatalError("Cannot find location in array")
        }
        return $locations[locationIndex]
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrowseView()
        }
    }
}
