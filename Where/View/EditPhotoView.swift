//
//  EditPhotoView.swift
//  Where
//
//  Created by Evader on 28/6/21.
//

import SwiftUI
import Introspect

struct NewPoint: Identifiable {
    var id = UUID()
    var location: CGPoint
}

struct EditPhotoView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var photo: Photo
    @State var uiTabarController: UITabBarController?
    @State var points: [NewPoint] = []
    @State var tapPosition: CGPoint = .zero
    @State var scale: CGFloat = 1.0
    
    @GestureState private var dragState = DragState.inactive
    
    var body: some View {
        let drag = DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded { value in
                let startLoc = value.startLocation
                let endLoc = value.location
                
                if abs(startLoc.x - endLoc.x) <= 10 && abs(startLoc.y - endLoc.y) <= 10 {
                    print("tap found")
                    self.points.append(NewPoint(location: startLoc))
                }
            }
            .onChanged { value in
                self.tapPosition = value.startLocation
                print("val changing")
            }
        
        let pinch = MagnificationGesture()
            .onChanged { scale in
                self.scale = scale.magnitude
            }
            .onEnded { scale in
                self.scale = scale.magnitude
            }
        
        ZStack {
            Image(uiImage: photo.image)
                .resizable()
                .scaledToFit()
                .scaleEffect(self.scale)
                .gesture(pinch)
                .gesture(drag)
            // hide tab bar
            .introspectTabBarController{ (UITabBarController) in
                UITabBarController.tabBar.isHidden = true
                uiTabarController = UITabBarController
            }.onDisappear{
                uiTabarController?.tabBar.isHidden = false
            }
            
            Group {
                ForEach(points, id: \.id) { point in
                    Circle()
                        .frame(width: 20, height: 20)
                        .offset(self.getOffset(point.location))
                }
            }

        }
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .gesture(drag)
    }
    
    private func getOffset(_ originalOffset: CGPoint) -> CGSize {
        let xOffset = (-1 * (UIScreen.main.bounds.width/2) + originalOffset.x)
        let yOffset = (-1 * (UIScreen.main.bounds.height/2) + originalOffset.y)
        
        return CGSize(width: xOffset, height: yOffset)
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}



//struct EditPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPhotoView()
//    }
//}
