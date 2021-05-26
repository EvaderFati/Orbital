//
//  Locations.swift
//  Orbital
//
//  Created by Evader on 19/5/21.
//

import SwiftUI
import Foundation

struct LocationView: View {
    @State private var locations: [Location] = Location.data[0].locationsInside!
    @State private var isPopoverPresented = false
    @State private var isNewFolderPresented = false
    @State private var newLocationData = Location.Data()
    
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
                // The pop-up menu after clicking '+' button
                Menu {
                    Button(action: {}) {
                        Label("New photo", systemImage: "photo")
                    }
                    Button(action: { isNewFolderPresented = true }) {
                        Label("New folder", systemImage: "folder.badge.plus")
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }())
        }
        .sheet(isPresented: $isNewFolderPresented) {
            NavigationView {
                CreateFolderView(locationData: $newLocationData)
                    .navigationBarItems(leading: Button("Cancel") {
                        isNewFolderPresented = false
                    }, trailing: Button("Add") {
                        let newLocation = Location(name: newLocationData.name, isFolder: true, numOfItems: 0, locked: newLocationData.locked, date: Date(), locationsInside: nil)
                        locations.append(newLocation)
                        isNewFolderPresented = false
                    })
            }
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
