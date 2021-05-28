//
//  TabBar.swift
//  Orbital
//
//  Created by Evader on 21/5/21.
//

/**
 Discarded
 */

import SwiftUI

struct TabBar: View {
    var barNum: Int
    
    var body: some View {
        VStack {
            HStack(spacing: 50) {
                VStack {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 22))
                    Text("Browse")
                        .font(.system(size: 10))
                }
                .foregroundColor(barNum == 0 ? .blue : .gray)
                .frame(width: 76, height: 49, alignment: .center)
                
                VStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22, weight: .semibold))
                    Text("Search")
                        .font(.system(size: 10))
                }
                .foregroundColor(barNum == 1 ? .blue : .gray)
                .frame(width: 76, height: 49, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                    Text("User")
                        .font(.system(size: 10))
                }
                .foregroundColor(barNum == 2 ? .blue : .gray)
                .frame(width: 76, height: 49, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            
            Spacer()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(barNum: 0)
            .previewLayout(.fixed(width: 375, height: 83))
    }
}
