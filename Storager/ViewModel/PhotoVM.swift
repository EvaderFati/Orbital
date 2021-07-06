//
//  PhotoVM.swift
//  Where
//
//  Created by Evader on 27/6/21.
//

import SwiftUI
import CoreData

class PhotoVM: ObservableObject {
    @Published var name: String
    @Published var date: Date
    @Published var image: UIImage?
    @Published var folder: Folder?
    
    init(name: String, date: Date, image: UIImage?, folder: Folder?) {
        self.name = name
        self.date = date
        self.image = image
        self.folder = folder
    }
    
    init() {
        self.name = ""
        self.date = Date()
        self.image = nil
        self.folder = nil
    }
    
    func createPhoto(context: NSManagedObjectContext) {
        guard let image = self.image else {
            print("No valid image")
            return
        }
        Photo.createPhoto(image: image, folder: self.folder, context: context)
        do {
            try context.save()
            print("Created a Photo instance")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
