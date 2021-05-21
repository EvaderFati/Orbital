//
//  TableRow.swift
//  Orbital
//
//  Created by Evader on 21/5/21.
//

import SwiftUI

struct TableRow: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Kitchen")
                Text("21/3/21 - 5 items")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }.padding()
            
            Spacer()
            
            Image(systemName: "lock.fill")
                .padding()
                .foregroundColor(.gray)
        }
    }
}

struct TableRow_Previews: PreviewProvider {
    static var previews: some View {
        TableRow()
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
