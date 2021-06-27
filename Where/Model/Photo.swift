//
//  Photo.swift
//  Where
//
//  Created by Evader on 25/6/21.
//

import Foundation
import CoreData
import SwiftUI

extension Photo {
    static func fetchPhoto(folder: Folder?, name: String, context: NSManagedObjectContext) -> Photo {
        let request = fetchRequest(name: name, folder: folder)
        let photo = (try? context.fetch(request)) ?? []
        if let photo = photo.first {
            // if found, return it
            return photo
        } else {
            // if not, create a photo and return it
            let photo = Photo(context: context)
            createPhoto(image: photo.image, folder: photo.folder, context: context)
            return photo
        }
    }

    static func fetchRequest(name: String, folder: Folder?) -> NSFetchRequest<Photo> {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        guard let folder = folder else {
            // request in root folder
            request.predicate = NSPredicate(format: "name = %@ AND folder = nil", name)
            request.sortDescriptors = []
            return request
        }
        request.predicate = NSPredicate(format: "name = %@ AND folder = %@", name, folder)
        request.sortDescriptors = []
        return request
    }
    
    static func fetchRequest(folder: Folder?) -> NSFetchRequest<Photo> {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        guard let folder = folder else {
            // request in root folder
            request.predicate = NSPredicate(format: "folder = nil")
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            return request
        }
        request.predicate = NSPredicate(format: "folder = %@", folder)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
    static func createPhoto(image: UIImage, folder: Folder?, context: NSManagedObjectContext) {
        let newPhoto = Photo(context: context)
        newPhoto.name = "New Photo"
        newPhoto.date = Date()
        newPhoto.folder = folder
        newPhoto.image = image
    }
    
//    static func createPhoto(_ newPhoto: Photo, name: String, image: UIImage, folder: Folder?) {
//        newPhoto.name = name
//        newPhoto.date = Date()
//        newPhoto.image = image
//        newPhoto.folder = folder
//    }
    
    static func update(from photo: Photo, context: NSManagedObjectContext) {
        photo.objectWillChange.send()
        photo.folder?.objectWillChange.send() // TODO: check if it is necessary
        try? context.save()
    }
    
    var name_: String {
        get { name ?? "Untitled" }
        set { name = newValue }
    }
    var image: UIImage {
        get { UIImage(data: image_!)! }
        set { image_  = newValue.jpegData(compressionQuality: 1)}
    }
}
