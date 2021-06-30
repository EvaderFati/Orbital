//
//  EditPhotoView.swift
//  Where
//
//  Created by Evader on 28/6/21.
//

import SwiftUI
import Introspect

struct PointView: View {
    @ObservedObject var photo: Photo
    @State private var uiTabarController: UITabBarController?
    @State private var points: [PointVM] = []
    @State private var tapLocation: CGPoint = .zero
    @State private var scale: CGFloat = 1.0
    @State private var currentPointNum: Int = -1
    @State private var showSheet: Bool = false
    
    @GestureState private var dragState = DragState.inactive
    
    let imageHeight: Double
    let imageWidth: Double
    
    init(photo: Photo) {
        self.photo = photo
        var tempPoints: [PointVM] = []
        
        if let points = photo.points {
            points.forEach { point in
                tempPoints.append(PointVM(point: point as! Point))
            }
            self.points = tempPoints
        }
        imageWidth = UIScreen.main.bounds.width
        imageHeight = photo.image.size.height * imageWidth / photo.image.size.width
    }
    
    var body: some View {
        // tap to add points
        let drag = DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded { value in
                let startLoc = value.startLocation
                let endLoc = value.location
                
                if abs(startLoc.x - endLoc.x) <= 10 && abs(startLoc.y - endLoc.y) <= 10 {
                    print("tap found")
                    self.points.append(PointVM(location: startLoc))
                    self.currentPointNum = self.points.count - 1
                    self.showSheet = true
                }
            }
            .onChanged { value in
                self.tapLocation = value.startLocation
                print("val changing")
            }
        
        // zoom in/out images
//        let pinch = MagnificationGesture()
//            .onChanged { scale in
//                self.scale = scale.magnitude
//            }
//            .onEnded { scale in
//                self.scale = scale.magnitude
//            }
        
        ZStack {
            Image(uiImage: photo.image)
                .resizable()
                .scaledToFit()
//                .scaleEffect(self.scale)
//                .gesture(pinch)
                .gesture(drag)
            // hide tab bar
            .introspectTabBarController{ (UITabBarController) in
                UITabBarController.tabBar.isHidden = true
                uiTabarController = UITabBarController
            }.onDisappear{
                uiTabarController?.tabBar.isHidden = false
            }
            
            ZStack {
                Group {
                    ForEach(points, id: \.id) { point in
                        Circle()
                            .frame(width: 20, height: 20)
                            .position(x: point.location.x, y: point.location.y + imageHeight/2 - UIScreen.main.bounds.height/2)
//                            .offset(self.getOffset(point.location))
                    }
                }
            }
            .frame(width: self.imageWidth, height: self.imageHeight)
        }
//        .background(colorScheme == .dark ? Color.black : Color.white)
        .sheet(isPresented: $showSheet) {
            NavigationView { 
                List {
                    TextField("Name", text: $points[currentPointNum].name)
                        .navigationBarItems(leading: Button("Cancel") {
                            self.showSheet = false
                        }, trailing: Button(action: addPoint, label: { Text("Add") }))
                }
            }
        }
    }
    
    private func addPoint() {
        withAnimation {
            
        }
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



//struct PointView_Previews: PreviewProvider {
//    static var previews: some View {
//        PointView()
//    }
//}
