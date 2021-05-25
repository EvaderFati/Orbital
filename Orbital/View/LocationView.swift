//
//  Locations.swift
//  Orbital
//
//  Created by Evader on 19/5/21.
//

import SwiftUI

struct LocationView: View {
    @State private var locations: [Location] = Location.data[0].locationsInside!
    @State private var isPopoverPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar()
                
                List {
                    ForEach(locations) { location in
                        NavigationLink(destination: Text("")) {
                            TableRow(location: binding(for: location))
                        }
                    }
                }
                .listStyle(InsetListStyle())
                
                TabBar(barNum: 0)
                    .frame(height: 49)
            }
            .navigationBarTitle("Home")
            .navigationBarItems(trailing: {
                Menu {
                    Button(action: {}) {
                        Label("New photo", systemImage: "photo")
                    }
                    Button(action: {}) {
                        Label("New folder", systemImage: "folder")
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }())
        }
    }
    
    private func binding(for location: Location) -> Binding<Location> {
        guard let locationIndex = locations.firstIndex(where: {$0.id == location.id}) else {
            fatalError("Cannot find location in array")
        }
        return $locations[locationIndex]
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
