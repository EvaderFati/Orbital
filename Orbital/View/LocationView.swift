//
//  Locations.swift
//  Orbital
//
//  Created by Evader on 19/5/21.
//

import SwiftUI
import Foundation

struct LocationView: View {
    @Binding var location: Location
    @State private var isPopoverPresented = false
    @State private var isNewFolderPresented = false
    @State private var newLocationData = Location.Data()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar()
                
                List {
                    ForEach(location.locationsInside) { loc in
                        NavigationLink(destination: Text("")) {
                            TableRow(location: binding(for: loc))
                        }
                    }
                }
                .listStyle(InsetListStyle())
                
                TabBar(barNum: 0)
                    .frame(height: 49)
            }
            .navigationBarTitle(location.name)
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
                        let newLocation = Location(name: newLocationData.name, isFolder: true, numOfItems: 0, locked: newLocationData.locked, date: Date(), locationsInside: [])
                        location.locationsInside.append(newLocation)
                        isNewFolderPresented = false
                    })
            }
        }
    }
    
    private func binding(for loc: Location) -> Binding<Location> {
        guard let locationIndex = location.locationsInside.firstIndex(where: {$0.id == loc.id}) else {
            fatalError("Cannot find location in array")
        }
        return $location.locationsInside[locationIndex]
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(location: .constant(Location.data[0]))
    }
}
