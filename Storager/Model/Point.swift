//
//  Point.swift
//  Where
//
//  Created by Evader on 29/6/21.
//

import SwiftUI

extension Point {
    static func createPoint(_ newPoint: Point, pointVM: PointVM, x: Double, y: Double, photo: Photo) {
        newPoint.id = pointVM.id
        newPoint.name = pointVM.name
        newPoint.x = x
        newPoint.y = y
        newPoint.photo = photo
        newPoint.color_ = UIColor(pointVM.color).toHex
    }
    
    var location: CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    var color: Color {
        get { Color(UIColor(hex: color_ ?? "#ffffffff") ?? UIColor(Color.black)) }
        set { color_ = UIColor(newValue).toHex}
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    // Computed Properties
    var toHex: String? {
        return toHex()
    }

    // From UIColor to String
    func toHex(alpha: Bool = true) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
