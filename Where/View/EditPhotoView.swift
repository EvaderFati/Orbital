//
//  EditPhotoView.swift
//  Where
//
//  Created by Evader on 28/6/21.
//

import SwiftUI
import Introspect

struct EditPhotoView: View {
    @ObservedObject var photo: Photo
    @State var uiTabarController: UITabBarController?
    
    var body: some View {
        Image(uiImage: photo.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
        // hide tab bar
        .introspectTabBarController{ (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
    }
}

//struct EditPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPhotoView()
//    }
//}
