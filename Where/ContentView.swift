//
//  ContentView.swift
//  Where
//
//  Created by Evader on 24/6/21.
//

import SwiftUI
import CoreData
import AuthenticationServices

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selection = 0

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true),
                          NSSortDescriptor(keyPath: \Photo.name, ascending: true)],
        animation: .default)
    private var folders: FetchedResults<Folder>

    var body: some View {
//        NavigationView{
//            List {
//                ForEach(folders) { folder in
//                    Text("Folder of \(folder.name!)")
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .navigationBarItems(trailing: Button("Add") {
//                addItem()
//            })
//        }
        TabView(selection: $selection) {
            NavigationView { FolderView(nil) }
                .navigationViewStyle(StackNavigationViewStyle()) // Fixing displayModeButtonItem assert
                .tabItem {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 22))
                    Text("Browse")
                        .font(.system(size: 10))
                }
                .tag(0)
            NavigationView { Text("Search") }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22, weight: .semibold))
                    Text("Search")
                        .font(.system(size: 10))
                }
                .tag(1)
            NavigationView { UserView(
                loggedIn: checkAutoLogin(),
                userName: UserDefaults.standard.string(forKey: "AppleUserFirstName") ?? "") }
                .tabItem {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                    Text("User")
                        .font(.system(size: 10))
                }
                .tag(2)
        }
    }

    private func checkAutoLogin() -> Bool {
        let userId = UserDefaults.standard.string(forKey: "AppleUserID") ?? ""
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        appleIDProvider.getCredentialState(forUserID: userId) { (credentialState, error) in
            if credentialState == .authorized {
                print("Auto login successful")
            } else {
                print("Auto login not successful")
            }
        }
        return userId == "" ? false : true
    }
//    private func addItem() {
//        withAnimation {
//            let newFolder = Folder(context: viewContext)
//            newFolder.name = "Folder Name"
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { folders[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
