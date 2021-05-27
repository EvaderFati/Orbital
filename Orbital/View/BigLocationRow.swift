//
//  BigLocationRow.swift
//  Orbital
//
//  Created by Qianyi Wang on 2021/5/26.
//

import SwiftUI

struct BigLocationRow: View {
    
    var location: Location
    
    
    var body: some View {
        
        HStack {
            Image(systemName: "folder")
                .padding(.leading)
                .font(.system(size: 20))
            
            Text(location.name)
                .padding()
            
            Spacer()
            
            Image(systemName: "lock.fill")
                .padding()
                .foregroundColor(.gray)
                .opacity(location.locked ? 1 : 0)
                
            
            
            
            
            
        }
    }
}

struct BigLocationRow_Previews: PreviewProvider {
    static var previews: some View {
        BigLocationRow(location: Location.data[0])
            .previewLayout(.fixed(width: 375, height: 20))
    }
}
