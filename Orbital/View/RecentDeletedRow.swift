//
//  RecentDeletedRow.swift
//  Orbital
//
//  Created by Qianyi Wang on 2021/5/26.
//

import SwiftUI

struct RecentDeletedRow: View {
    
    var body: some View {
        HStack {
            Image(systemName: "trash")
                .padding(.leading)
                .font(.system(size: 20))
            
            Text("Recently Deleted")
                .padding()
            
            Spacer()
            
        
                
            
            
            
            
            
        }
    }

}

struct RecentDeletedRow_Previews: PreviewProvider {
    static var previews: some View {
        RecentDeletedRow()
            .previewLayout(.fixed(width: 375, height: 20))
    }
}
