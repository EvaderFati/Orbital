//
//  SearchBar.swift
//  Where
//
//  Created by Evader on 20/5/21.
//
import SwiftUI
//import CoreData

struct SearchBar: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest var folders: FetchedResults<Folder>
//    @FetchRequest var photos: FetchedResults<Photo>
//
//
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search", text: $searchText,
                          onEditingChanged: { isEditing in self.showCancelButton = true
                          },
                          onCommit: {
                            print("onCommit")
//                            let requestFolder = Folder.fetchRequestAll()
//                            _folders = FetchRequest(fetchRequest: requestFolder)
                          })
                    .foregroundColor(.primary)

                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        
            if showCancelButton  {
                Button("Cancel") {
                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                    self.searchText = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(showCancelButton)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar()
//            .previewLayout(.sizeThatFits)
//    }
//}
