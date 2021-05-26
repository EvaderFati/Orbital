//
//  CreateFolderView.swift
//  Orbital
//
//  Created by Evader on 26/5/21.
//

import SwiftUI

struct CreateFolderView: View {
    @Binding var locationData: Location.Data
    
    var body: some View {
        List {
            TextField("Folder Name", text: $locationData.name)
            Toggle("Require password", isOn: $locationData.locked)
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct CreateFolderView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFolderView(locationData: .constant(Location.data[0].data))
    }
}
