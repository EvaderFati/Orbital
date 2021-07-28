//
//  Folder.swift
//  Where
//
//  Created by Evader on 25/6/21.
//

import Foundation
import CoreData

extension Folder {
    static func createFolder(_ newFolder: Folder, name: String, isLocked: Bool, parent: Folder?) {
        newFolder.id = UUID()
        newFolder.name = name
        newFolder.date = Date()
        newFolder.parent = parent
        newFolder.children = NSSet()
        newFolder.isLocked = isLocked
        newFolder.photos = NSSet()
    }
    
    static func fetchRequest(parent: Folder?) -> NSFetchRequest<Folder> {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
        guard let parent = parent else {
            request.predicate = NSPredicate(format: "parent = nil")
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            return request
        }
        request.predicate = NSPredicate(format: "parent = %@", parent)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
    static func fetchRequestAll() -> NSFetchRequest<Folder> {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
    static func update(from folder: Folder, context: NSManagedObjectContext) {
        folder.objectWillChange.send()
        try? context.save()
    }
    
    var children: NSSet {
        get { children_ ?? NSSet() }
        set { children_ = newValue }
    }
    
    var photos: NSSet {
        get { photos_ ?? NSSet() }
        set { photos_ = newValue }
    }
    
    // TODO: numOfItems = numOfFolders + numOfPhotos
    var numOfItems: Int {
        return children.count + photos.count
    }
}
