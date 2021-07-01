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
            VStack {
                HStack {
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
                
                TextField("Enter name", text: $photo.name_)
                    .padding(EdgeInsets(top: 10, leading: 30, bottom: 0, trailing: 0))
                    .font(.system(size: 32, weight: .bold, design: .default))
                Divider()
                
                List {
                    Section(header: HStack {
                        Text("Items")
                            .font(.headline)
//                            .foregroundColor(.primary)
//                            .textCase(.none)
                        Spacer()
                        Button(action: {
                            self.addNewItem = true
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }) {
                        if let points = self.photo.points {
                            ForEach(Array(points as Set), id: \.self) { point in
                                NavigationLink(destination: Text("Single point view")) {
                                    HStack {
                                        Text((point as! Point).name!)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarItems(trailing: Button("Done") {
                Photo.update(from: photo, context: viewContext)
                presentationMode.wrappedValue.dismiss()
            })
        }
        .background (
            NavigationLink(destination: PointView(photo: photo), isActive: $addNewItem) {
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
