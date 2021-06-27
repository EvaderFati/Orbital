//
//  EditPhotosView.swift
//  Where
//
//  Created by Evader on 30/5/21.
//

import SwiftUI
import PhotosUI

struct EditPhotosView: View {
    @Binding var image: UIImage?
    @State private var name: String = ""
    @State private var isOn: Bool = true
    @State private var addNewItem: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                HStack{
                    // Image("kitchen")
                    Image(uiImage: image!) // TODO: force unwrapping here
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 0.9 * geo.size.width)
                        .cornerRadius(20)
                }
                .frame(width: geo.size.width)
                
                List {
                    Section {
                        HStack {
                            Text("Name: ")
                                .font(.headline)
                            TextField("Enter name", text: $name)
                        }
                        .frame(height: 40)
                        Toggle("Require password", isOn: $isOn)
                            .font(.headline)
                    }
                    Section {
                        HStack {
                            Text("Items")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                self.addNewItem = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        }
                        List {
                            
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationBarItems(trailing: Button("Add") {
            
        })
    }
}

struct EditPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotosView(image: .constant(UIImage()))
    }
}

