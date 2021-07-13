//
//  FolderView.swift
//  Where
//
//  Created by Evader on 25/6/21.
//

import SwiftUI
import CoreData

struct FolderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    @FetchRequest var folders: FetchedResults<Folder>
    @FetchRequest var photos: FetchedResults<Photo>

    @State private var isAddingPhoto = false
    @State private var isAddingFolder = false
    @State private var isImportingPhoto = false
    @State private var newFolderName = ""
    @State private var newFolderIsLocked = false
    @State private var newPhoto: PhotoVM = PhotoVM()
    @State private var isDuplicateName = false
    @State private var searchText = ""

    let parent: Folder?
    
    init(_ parent: Folder?) {
        let requestFolder = Folder.fetchRequest(parent: parent)
        let requestPhoto = Photo.fetchRequest(folder: parent)
        _folders = FetchRequest(fetchRequest: requestFolder, animation: .default)
        _photos = FetchRequest(fetchRequest: requestPhoto, animation: .default)
        self.parent = parent
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)
            List {
                ForEach(folders.filter({ $0.name!.contains(searchText) || searchText.isEmpty })) { folder in
                    NavigationLink(destination: FolderView(folder)) {
                        FolderListEntry(folder: folder)
                    }
                }
                .onDelete(perform: deleteFolders)
                ForEach(photos.filter({ $0.name!.contains(searchText) || searchText.isEmpty })) { photo in
                    NavigationLink(destination: PhotoView(photo: photo)) {
                        PhotoListEntry(photo: photo)
                    }
                }
                .onDelete(perform: deletePhotos)
            }
        }
        .navigationBarTitle(parent?.name ?? "Browse", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { isAddingPhoto = true}) {
                        Label("New Photo", systemImage: "photo")
                    }
                    Button(action: { isAddingFolder = true }) {
                        Label("New Folder", systemImage: "folder.badge.plus")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 22))
                }
            }
        }
        .actionSheet(isPresented: $isAddingPhoto) {
            ActionSheet(title: Text("Add photos"),
                        message: Text("Choose between the following"),
                        buttons: [
                            .cancel(),
                            .default(
                                Text("Import from gallery"),
                                action: { isImportingPhoto = true }
                            ),
                            .default(
                                Text("Take new photos"),
                                action: {}
                            )
                        ]
            )
        }
        .sheet(isPresented: $isAddingFolder) {
            NavigationView {
                if #available(iOS 15.0, *) {
                    CreateFolderView(newFolderName: $newFolderName, newFolderIsLocked: $newFolderIsLocked)
                        .navigationBarTitle("Edit Folder", displayMode: .inline)
                        .navigationBarItems(leading: Button("Cancel") {
                            isAddingFolder = false
                        }, trailing: Button(action: addFolder, label: { Text("Done") }).alert("This folder has already existed",isPresented: $isDuplicateName){Button("Return to main page"){isAddingFolder = false}
                            
                        })
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .sheet(isPresented: $isImportingPhoto) {
            PhotoPicker(photo: newPhoto, folder: parent)
        }
//        .background(
//            NavigationLink(destination: PhotoView(photo: Photo.createPhoto(image: inputImage!, folder: parent, context: viewContext)), isActive: .constant(inputImage != nil)) {
//                EmptyView()
//            }
//        )
    }
    
    private func addFolder() {
        withAnimation {
            let request = NSFetchRequest<Folder>(entityName: "Folder")
            request.predicate = NSPredicate(format: "name = %@", newFolderName)
            let results = try? viewContext.fetch(request)
            if results == [] {
                isDuplicateName = false
                let newFolder = Folder(context: viewContext)
                Folder.createFolder(newFolder, name: newFolderName, isLocked: newFolderIsLocked, parent: self.parent)
                isAddingFolder = false
            }else {
                isDuplicateName = true

            }
            


            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
 
    private func deletePhotos(offsets: IndexSet) {
        withAnimation {
            offsets.map { photos[$0] }.forEach { photo in
                (photo ).points?.forEach{ viewContext.delete($0 as! NSManagedObject) }
                viewContext.delete(photo as NSManagedObject)
            }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteFolders(offsets: IndexSet) {
        withAnimation {
            offsets.map { folders[$0] }.forEach { folder in
                if (folder.numOfItems == 0) {
                    viewContext.delete(folder)
                } else {
                    deleteSubFolders(parent: folder)
                }
            }

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteSubFolders(parent folder: Folder) {
        if (folder.children.count == 0) {
            if (folder.photos.count == 0) {
                viewContext.delete(folder)
                return
            } else {
                folder.photos.forEach { photo in
                    (photo as! Photo).points?.forEach{ viewContext.delete($0 as! NSManagedObject) }
                    viewContext.delete(photo as! NSManagedObject)
                }
            }
        } else {
            folder.children.forEach { child in
                deleteSubFolders(parent: child as! Folder)
            }
            viewContext.delete(folder)
            return
        }
    }
}

struct CreateFolderView: View {
    @Binding var newFolderName: String
    @Binding var newFolderIsLocked: Bool
    
    var body: some View {
        List {
            Section(header: Text("Name")) {
                TextField("Enter Folder Name", text: $newFolderName)
            }
            
            Section(header: Text("Settings")) {
                Toggle("Require Password", isOn: $newFolderIsLocked)
            }
        }
        .listStyle(InsetGroupedListStyle())
//        VStack {
//            Text("Name")
//                .font(.headline)
//            Section {
//                TextField("Folder Name", text: $newFolderName)
//            }
//            List {
//
//                Toggle("Require Password", isOn: $newFolderIsLocked)
//            }
//        }
    }
}

struct FolderListEntry: View {
    @ObservedObject var folder: Folder
    
    var body: some View {
        HStack {
            Image(systemName: "folder")
                .padding(.leading)
                .foregroundColor(.blue)
                .font(.system(size: 24))
            VStack(alignment: .leading) {
                Text(folder.name ?? "Untitled")
                Text(folder.numOfItems == 0
                     ? "\(dateToString(folder.date)) - empty"
                     : folder.numOfItems == 1
                        ? "\(dateToString(folder.date)) - \(folder.numOfItems) item"
                        : "\(dateToString(folder.date)) - \(folder.numOfItems)")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }.padding()
        }
    }
}

struct PhotoListEntry: View {
    @ObservedObject var photo: Photo
    
    var body: some View {
        HStack {
            Image(systemName: "photo")
                .padding(.leading)
                .foregroundColor(.blue)
                .font(.system(size: 24))
            VStack(alignment: .leading) {
                Text(photo.name ?? "Untitled")
                Text("\(dateToString(photo.date))")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }.padding()
        }
    }
}

func dateToString(_ date: Date?) -> String {
    guard let date = date else {
        return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/M/d"
    return dateFormatter.string(from: date)
}


struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFolderView(newFolderName: .constant("Folder"), newFolderIsLocked: .constant(true))
    }
}
