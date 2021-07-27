//
//  ContentView.swift
//  Storager
//
//  Created by Evader on 24/6/21.
//

import SwiftUI
import CoreData
import AuthenticationServices

struct ContentView: View {
    @AppStorage("walkthroughPage") var currentPage = 1
    let totalPages = 3
    
    var body: some View {
        if currentPage > totalPages {
            HomeView()
        } else {
            OnboardingView()
        }
    }
}

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selection = 0

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true),
                          NSSortDescriptor(keyPath: \Photo.name, ascending: true)],
        animation: .default)
    private var folders: FetchedResults<Folder>

    var body: some View {
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
            NavigationView { SearchView() }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22, weight: .semibold))
                    Text("Search")
                        .font(.system(size: 10))
                }
                .tag(1)
//            NavigationView { UserView(
//                loggedIn: checkAutoLogin(),
//                userName: UserDefaults.standard.string(forKey: "AppleUserFirstName") ?? "") }
//                .tabItem {
//                    Image(systemName: "person.fill")
//                        .font(.system(size: 24))
//                    Text("User")
//                        .font(.system(size: 10))
//                }
//                .tag(2)
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
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
