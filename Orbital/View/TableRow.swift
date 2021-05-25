//
//  TableRow.swift
//  Orbital
//
//  Created by Evader on 21/5/21.
//

import SwiftUI
import Foundation

struct TableRow: View {
    @Binding var location: Location
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(location.name)
                Text("\(dateToString(location.date)) - \(location.numOfItems) items")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }.padding()
            
            Spacer()
            
            Image(systemName: "lock.fill")
                .padding()
                .foregroundColor(.gray)
                .opacity(location.locked ? 1 : 0)
        }
    }
    
    private func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/M/d"
        return dateFormatter.string(from: date)
    }
}

struct TableRow_Previews: PreviewProvider {
    static var previews: some View {
        TableRow(location: .constant(Location.data[0].locationsInside![0]))
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
