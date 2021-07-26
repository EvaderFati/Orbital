//
//  CameraPicker.swift
//  Storager
//
//  Created by Evader on 26/7/21.
//

import UIKit
import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var isPresented
    @Environment(\.managedObjectContext) var viewContext

    @ObservedObject var photo: PhotoVM
    
    let folder: Folder?
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: CameraPicker
        
        init(picker: CameraPicker) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print("image format not supported")
                return
            }
            self.picker.photo.image = selectedImage
            self.picker.photo.folder = self.picker.folder
            self.picker.photo.createPhoto(context: self.picker.viewContext)
            self.picker.isPresented.wrappedValue.dismiss()
        }
        
    }
}
