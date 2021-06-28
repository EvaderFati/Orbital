//
//  BrowseView.swift
//  Where
//
//  Created by Evader on 28/6/21.
//

import SwiftUI
import CoreData

struct BrowseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var folders: FetchedResults<Folder>

    @State private var isAddingFolder = false
    @State private var newFolderName = ""
    @State private var newFolderIsLocked = false

    let parent: Folder?
    
    init() {
        let requestFolder = Folder.fetchRequest(parent: nil)
        _folders = FetchRequest(fetchRequest: requestFolder, animation: .default)
        self.parent = nil
    }
    
    var body: some View {
        VStack {
            SearchBar()
            List {
                ForEach(folders) { folder in
                    NavigationLink(destination: FolderView(folder)) {
                        FolderListEntry(folder: folder)
                    }
                }
                .onDelete(perform: deleteFolders)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { isAddingFolder = true }) {
                        Label("New Folder", systemImage: "folder.badge.plus")
                    }
                } label: { Image(systemName: "ellipsis.circle") }
            }
        }
        .sheet(isPresented: $isAddingFolder) {
            NavigationView {
                CreateFolderView(newFolderName: $newFolderName, newFolderIsLocked: $newFolderIsLocked)
                    .navigationBarItems(leading: Button("Cancel") {
                        isAddingFolder = false
                    }, trailing: Button(action: addFolder, label: { Text("Add") }))
            }
        }
    }
    
    private func addFolder() {
        withAnimation {
            let newFolder = Folder(context: viewContext)
            Folder.createFolder(newFolder, name: newFolderName, isLocked: newFolderIsLocked, parent: self.parent)
            isAddingFolder = false

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

//struct FolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderView()
//    }
//}
