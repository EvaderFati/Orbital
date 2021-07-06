//
//  UserView.swift
//  Where
//
//  Created by Evader on 27/6/21.
//

import SwiftUI
import AuthenticationServices

struct AppleUser: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else { return nil }
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

struct UserView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var loggedIn: Bool
    var userName: String
    @State private var isPasswordOn = false
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 80))
            Text(userName)
                .font(.largeTitle)
            
            List {
                Toggle("Password protection", isOn: $isPasswordOn)
                if loggedIn {
                    Button("Log out") {
                        // TODO: Handle log out
                    }
                    .frame(width: 300, height: 45, alignment: .center)
                } else {
                    SignInWithAppleButton(.signIn, onRequest: configure, onCompletion: handle)
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                        .frame(height: 45)
                }
            }
            
            Spacer()
        }
    }
    
    private func configure(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
//        request.nonce = ""
    }
    
    private func handle(_ authResult: Result<ASAuthorization, Error>) {
        switch authResult {
        case .success(let auth):
            print(auth)
            switch auth.credential {
            case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                if let appleUser = AppleUser(credentials: appleIdCredentials),
                   let appleUserData = try? JSONEncoder().encode(appleUser) {
                    UserDefaults.standard.set(appleUserData, forKey: appleUser.userId) // Unused
                    UserDefaults.standard.set(appleUser.userId, forKey: "AppleUserID")
                    UserDefaults.standard.set(appleUser.firstName, forKey: "AppleUserFirstName")
                    
                    print("saved apple user", appleUser)
                } else {
                    guard
                        let appleUserData = UserDefaults.standard.data(forKey: appleIdCredentials.user),
                        let appleUser = try? JSONDecoder().decode(AppleUser.self, from: appleUserData)
                    else { return }

                    print(appleUser)
                }
                
            default:
                print(auth.credential)
            }
            
        case .failure(let error):
            print(error)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(loggedIn: true, userName: "Evader")
    }
}
