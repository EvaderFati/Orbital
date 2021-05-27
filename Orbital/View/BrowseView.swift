//
//  BrowseView.swift
//  Orbital
//
//  Created by Qianyi Wang on 2021/5/26.
//

import SwiftUI

struct BrowseView: View {
    
 @State private var overalllocations: [Location] = Location.data
    var body: some View {
        NavigationView {
            VStack {

                
                BrowseList().padding()
                TabBar(barNum: 0)
                    .frame(height: 49)
    
              
                   
            
            }
            .navigationTitle(
                "Browse")
            
            

        }

    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
