//
//  BrowseList.swift
//  Orbital
//
//  Created by Qianyi Wang on 2021/5/27.
//

import SwiftUI

struct BrowseList: View {
    
    @State private var overalllocations: [Location] = Location.data
    
    var body: some View {
        VStack {
            
            List {
                VStack {
                    SearchBar().padding()
                    Spacer()
                    Spacer()
                    
                    HStack{
                        Text("Locations").bold().font(.system(size:30))
                        Spacer()
                    }
                    
                }
                ForEach(overalllocations) { location in
                    NavigationLink(destination: LocationView(location:.constant(location))) {
                        BigLocationRow(location: location)
                            .frame(width:375,height: 20 )
                    }
                }
                
                NavigationLink(
                    destination: RecentDeletedPage()
                    ) {
                    RecentDeletedRow()
                        .frame(width:375, height:20)
                }
                
                VStack {
                    Spacer().frame(height: 100)
                    
                    HStack{
                        Text("Tags").bold().font(.system(size:30))
                        Spacer()
                    }
                    
                }
                
                exstar()
                    .frame(width:375,height: 20 )
                
                Spacer().frame(height: 500)

                
                
                
                
                
                
                
            }
            .listStyle(GroupedListStyle())
        }
        
        
        
    }
}

struct BrowseList_Previews: PreviewProvider {
    static var previews: some View {
        BrowseList()
            .previewLayout(.sizeThatFits)
    }
}
