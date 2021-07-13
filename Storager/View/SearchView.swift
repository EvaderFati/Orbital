//
//  SearchView.swift
//  Storager
//
//  Created by Evader on 11/7/21.
//

import SwiftUI

struct SearchView: View {
    @FetchRequest var points: FetchedResults<Point>
    @FetchRequest var photos: FetchedResults<Photo>
    @FetchRequest var folders: FetchedResults<Folder>
    
    @State private var searchText = ""

    init() {
        let requestPoint = Point.fetchRequestAll()
        let requestPhoto = Photo.fetchRequestAll()
        let requestFolder = Folder.fetchRequestAll()
        _points = FetchRequest(fetchRequest: requestPoint, animation: .default)
        _photos = FetchRequest(fetchRequest: requestPhoto, animation: .default)
        _folders = FetchRequest(fetchRequest: requestFolder, animation: .default)
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)
            List {
                Section(header: Text("Points")) {
                    ForEach(points.filter( { $0.name!.contains(searchText) || searchText.isEmpty })) { point in
                        NavigationLink(destination: SinglePointView(point: point)) {
                            PointListEntry(point: point)
                        }
                    }
                }
                Section(header: Text("Photos")) {
                    ForEach(photos.filter({ $0.name!.contains(searchText) || searchText.isEmpty })) { photo in
                        NavigationLink(destination: PhotoView(photo: photo)) {
                            PhotoListEntry(photo: photo)
                        }
                    }
                }
                Section(header: Text("Folders")) {
                    ForEach(folders.filter({ $0.name!.contains(searchText) || searchText.isEmpty })) { folder in
                        NavigationLink(destination: FolderView(folder)) {
                            FolderListEntry(folder: folder)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Search")
    }
}

struct PointListEntry: View {
    @ObservedObject var point: Point
    
    var body: some View {
        HStack {
            Circle()
                .stroke(lineWidth: 3.0)
                .frame(width: 20, height: 20)
                .foregroundColor(point.color)
            Text((point).name!)
            Spacer()
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
