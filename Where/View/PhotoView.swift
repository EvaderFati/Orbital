//
//  PhotoView.swift
//  Where
//
//  Created by Evader on 25/6/21.
//

import SwiftUI

struct PhotoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var photo: Photo
    @State private var addNewItem = false
    @State private var name: String = ""

    var body: some View {
        GeometryReader { geo in
            VStack{
                HStack{
                    // Image("kitchen")
                    Image(uiImage: photo.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 0.9 * geo.size.width)
                        .cornerRadius(20)
//                        .gesture(
//                            TapGesture()
//                                .onEnded(<#T##action: (()) -> Void##(()) -> Void#>)
//                        )
                }
                .frame(width: geo.size.width)
                
                List {
                    Section {
                        HStack {
                            Text("Name: ")
                                .font(.headline)
                            TextField("Enter name", text: $photo.name_)
                        }
                        .frame(height: 40)
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
            .navigationBarItems(trailing: Button("Add") {
                Photo.update(from: photo, context: viewContext)
                presentationMode.wrappedValue.dismiss()
            })
        }
        .background (
            NavigationLink(destination: EditPhotoView(photo: photo), isActive: $addNewItem) {
                EmptyView()
            }
        )
    }
}

//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoView()
//    }
//}
