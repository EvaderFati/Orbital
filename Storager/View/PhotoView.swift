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
                    Image(uiImage: photo.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 0.9 * geo.size.width)
                        .cornerRadius(20)
                }
                .frame(width: geo.size.width)
                
                TextField("Enter name", text: $name)
                    .padding(EdgeInsets(top: 10, leading: 30, bottom: 0, trailing: 0))
                    .font(.system(size: 32, weight: .bold, design: .default))
                Divider()
                
                List {
                    Section(header: HStack {
                        Text("Items")
                            .font(.headline)
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
                                NavigationLink(destination: SinglePointView(point: point as! Point)) {
                                    HStack {
                                        Circle()
                                            .stroke(lineWidth: 3.0)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor((point as! Point).color)
                                        Text((point as! Point).name ?? "")
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarItems(trailing: Button("Done") {
                photo.name_ = self.name
                Photo.update(from: photo, context: viewContext)
                presentationMode.wrappedValue.dismiss()
            })
//            .onTapGesture {
//                self.hideKeyboard()
//            }
        }
        .background (
            NavigationLink(destination: PointsView(photo: photo), isActive: $addNewItem) {
                EmptyView()
            }
        )
        .onAppear {
            name = photo.name_
        }
    }
}

//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoView()
//    }
//}
