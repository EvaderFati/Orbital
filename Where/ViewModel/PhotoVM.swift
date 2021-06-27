//
//  PhotoVM.swift
//  Where
//
//  Created by Evader on 27/6/21.
//

import SwiftUI
import CoreData

class PhotoVM: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext
    
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
    
    func createPhoto() {
        guard let image = image else {
            print("Invalid image")
            return
        }
        Photo.createPhoto(image: image, folder: folder, context: viewContext)
        folder?.objectWillChange.send()
    }
}
