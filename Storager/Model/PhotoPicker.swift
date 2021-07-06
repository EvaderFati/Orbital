//
//  PhotoPicker.swift
//  Where
//
//  Created by Evader on 30/5/21.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext

    @ObservedObject var photo: PhotoVM
    @State private var selectedImage: UIImage?
    let folder: Folder?
        
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> PhotoPicker.Coordinator {
        return Coordinator(self)
    }
    
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            let imageResult = results[0]
            
            if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = selectedImage as? UIImage
                            if let image = self.parent.selectedImage {
                                self.parent.photo.image = image
                                self.parent.photo.folder = self.parent.folder
                                self.parent.photo.createPhoto(context: self.parent.viewContext)
                            }
                        }
                    }
                }
            }
        }
        
        private let parent: PhotoPicker
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
    }
}

