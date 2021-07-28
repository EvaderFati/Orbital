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
    @State private var isTakingPhoto = false
    @State private var newFolderName = ""
    @State private var newFolderIsLocked = false
    @State private var newPhoto: PhotoVM = PhotoVM()
    @State private var searchText = ""
    
    // editing folder
    @State private var isEditingFolder = false
    @State private var folderId: UUID?
    
    // selecting folders or photos
    @State private var isSelecting = false
    @State private var multiSelection = Set<NSManagedObject>()

    let parent: Folder?
    
    init(_ parent: Folder?) {
        let requestFolder = Folder.fetchRequest(parent: parent)
        let requestPhoto = Photo.fetchRequest(folder: parent)
        _folders = FetchRequest(fetchRequest: requestFolder, animation: .default)
        _photos = FetchRequest(fetchRequest: requestPhoto, animation: .default)
        self.parent = parent
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)
            List(selection: $multiSelection) {
                ForEach(folders.filter({ $0.name!.contains(searchText) || searchText.isEmpty }), id: \.id) { folder in
                    NavigationLink(destination: FolderView(folder)) {
                        FolderListEntry(folder: folder)
                            .contextMenu {
                                VStack {
                                    Button(action: {
                                        self.newFolderName = folder.name!
                                        self.newFolderIsLocked = folder.isLocked
                                        self.folderId = folder.id!
                                        self.isEditingFolder = true
                                        self.isAddingFolder = true
                                    }) {
                                        Label("Edit", systemImage: "pencil.circle")
                                    }
                                    // TODO: Info sheet
                                    Button(action: {}) {
                                        Label("Info", systemImage: "info.circle")
                                    }
                                    Divider()
                                    Button(action: {
                                        print(folders.firstIndex(of: folder) ?? -1)
                                        deleteFolders(offsets: IndexSet(integer: folders.firstIndex(of: folder) ?? -1))
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    // TODO: for iOS 15 and above
//                                    Button(role: .destructive) {
//                                        // delete action
//                                    } label: {
//                                        Label("Delete", systemImage: "trash")
//                                            .foregroundColor(.red)
//                                    }
                                }
                            }
                    }
                }
                .onDelete(perform: deleteFolders)
                ForEach(photos.filter({ $0.name!.contains(searchText) || searchText.isEmpty })) { photo in
                    NavigationLink(destination: PhotoView(photo: photo)) {
                        PhotoListEntry(photo: photo)
                            .contextMenu {
                                VStack {
                                    Button(action: {}) {
                                        HStack {
                                            Text("Edit")
                                            Image(systemName: "pencil.circle")
                                        }
                                    }
                                }
                            }
                    }
                }
                .onDelete(perform: deletePhotos)
            }
            .listStyle(InsetGroupedListStyle())
            // select items
            .environment(\.editMode, .constant(self.isSelecting ? EditMode.active : EditMode.inactive))
            .animation(Animation.spring())
        }
        .navigationBarTitle(parent?.name ?? "Browse", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if self.isSelecting {
                    Button("Done") {
                        self.isSelecting.toggle()
                    }
                } else {
                    Menu {
                        Button(action: { isAddingPhoto = true}) {
                            Label("New Photo", systemImage: "photo")
                        }
                        Button(action: { isAddingFolder = true }) {
                            Label("New Folder", systemImage: "folder.badge.plus")
                        }
                        Button(action: { isSelecting.toggle() }) {
                            Label("Select", systemImage: "checkmark.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 22))
                    }
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
                                action: { isTakingPhoto = true }
                            )
                        ]
            )
        }
        .sheet(isPresented: $isAddingFolder) {
            NavigationView {
                CreateFolderView(newFolderName: $newFolderName, newFolderIsLocked: $newFolderIsLocked)
                    .navigationBarTitle("New Folder", displayMode: .inline)
                    .navigationBarItems(leading: Button("Cancel") {
                        isAddingFolder = false
                        isEditingFolder = false
                        newFolderName = ""
                        newFolderIsLocked = false
                    }, trailing: Button("Done") {
                        isEditingFolder ? editFolder() : addFolder()
                    })
            }
        }
        .sheet(isPresented: $isImportingPhoto) {
            PhotoPicker(photo: newPhoto, folder: parent)
        }
        .sheet(isPresented: $isTakingPhoto) {
            CameraPicker(photo: newPhoto, folder: parent)
        }
    }
    
    private func addFolder() {
        withAnimation {
            let newFolder = Folder(context: viewContext)
            Folder.createFolder(newFolder, name: newFolderName, isLocked: newFolderIsLocked, parent: self.parent)
            isAddingFolder = false
            newFolderName = ""
            newFolderIsLocked = false

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func editFolder() {
        withAnimation {
            let folder = folders.first(where: { $0.id == folderId })
            if folder != nil {
                folder!.name = newFolderName
                folder!.isLocked = newFolderIsLocked
                Folder.update(from: folder!, context: viewContext)
                print("folder edited")
            }
            newFolderName = ""
            newFolderIsLocked = false
            isEditingFolder = false
            isAddingFolder = false
        }
    }
    
    private func deletePhotos(offsets: IndexSet) {
        withAnimation {
            offsets.map { photos[$0] }.forEach { photo in
                photo.points?.forEach{ viewContext.delete($0 as! NSManagedObject) }
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
                    print("No subfolder")
                    viewContext.delete(folder)
                } else {
                    print("\(folder.numOfItems) subfolders")
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
        // no subfolder (but maybe has subphotos)
        if (folder.children.count == 0) {
            if (folder.photos.count == 0) { // no subphoto
                viewContext.delete(folder)
                return
            } else { // has subphotos
                folder.photos.forEach { photo in
                    (photo as! Photo).points?.forEach{ viewContext.delete($0 as! NSManagedObject) }
                    viewContext.delete(photo as! NSManagedObject)
                    viewContext.delete(folder)
                }
            }
        }
        // has subfolders
        else {
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
            .frame(height: 52)
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
            .frame(height: 52)
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


//struct FolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateFolderView(newFolderName: .constant("Folder"), newFolderIsLocked: .constant(true))
//    }
//}
