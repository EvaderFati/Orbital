//
//  EditPhotoView.swift
//  Where
//
//  Created by Evader on 28/6/21.
//

import SwiftUI
import Introspect

struct PointView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var photo: Photo
    @State private var uiTabarController: UITabBarController?
    @State private var points: [PointVM] = []
    @State private var tapLocation: CGPoint = .zero
    @State private var scale: CGFloat = 1.0
    @State private var currentPointNum: Int = -1
    @State private var isAddingPoint: Bool = false
    @State private var isChangingPoint: Bool = false
    @State private var newPoint: PointVM = PointVM()
    
    @GestureState private var dragState = DragState.inactive
    
    let imageHeight: CGFloat
    let imageWidth: CGFloat
    
    init(photo: Photo) {
        self.photo = photo
        self.imageWidth = UIScreen.main.bounds.width
        self.imageHeight = photo.image.size.height * imageWidth / photo.image.size.width
    }
    
    var body: some View {
        // tap to add points
        let add = DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded { value in
                let startLoc = value.startLocation
                let endLoc = value.location
                
                if abs(startLoc.x - endLoc.x) <= 10 && abs(startLoc.y - endLoc.y) <= 10 {
                    print("tap found")
                    self.newPoint.location = CGPoint(x: startLoc.x, y: startLoc.y  + imageHeight/2 - UIScreen.main.bounds.height/2)
                    self.isAddingPoint = true
                }
            }
            .onChanged { value in
                self.tapLocation = value.startLocation
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
                .gesture(add)

//                .scaleEffect(self.scale)
//                .gesture(pinch)
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
                            .position(x: point.location.x, y: point.location.y)
                            .gesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                    .updating($dragState) { drag, state, transaction in
                                        state = .dragging(translation: drag.translation)
                                    }
                                    .onEnded { value in
                                        self.isChangingPoint = true
                                    }
                                    .onChanged { value in
                                        self.currentPointNum = self.changeLocation(uuid: point.id.uuidString, newLoc: value.location)
                                    }
                            )
                    }
                }
            }
            .frame(width: self.imageWidth, height: self.imageHeight)
//            .gesture(add)
        }
        /*
         * Show all the existing points in the photo.
         * (Note: Cannot append an @State array during init() process.)
         */
        .onAppear{
            if let points = photo.points {
                points.forEach { point in
                    self.points.append(PointVM(point: point as! Point, imageWidth: self.imageWidth, imageHeight: self.imageHeight))
                }
            }
        }
        .sheet(isPresented: $isAddingPoint) {
            NavigationView { 
                List {
                    TextField("Name", text: $newPoint.name)
                        .navigationBarItems(leading: Button("Cancel") {
                            self.isAddingPoint = false
                        }, trailing: Button(action: addPoint, label: { Text("Add") }))
                }
            }
        }
        .sheet(isPresented: $isChangingPoint) {
            NavigationView {
                List {
                    TextField("Name", text: $points[currentPointNum].name)
                        .navigationBarItems(leading: Button("Cancel") {
                            self.isChangingPoint = false
                        }, trailing: Button(action: changePoint, label: { Text("Done") }))
                    Button(action: deletePoint, label: { Text("Delete")} )
                }
            }
        }
    }
    
    private func changeLocation(uuid: String, newLoc: CGPoint) -> Int{
        for i in 0..<points.count {
            if points[i].id.uuidString == uuid {
                points[i].location = CGPoint(x: newLoc.x, y: newLoc.y + imageHeight/2 - UIScreen.main.bounds.height/2)
                return i
            }
        }
        return -1
    }
    
    private func changePoint() {
        if let points = photo.points {
            points.forEach { point in
                if let point = point as? Point {
                    if point.id!.uuidString == self.points[currentPointNum].id.uuidString {
                        point.x = Double(self.points[currentPointNum].location.x / imageWidth)
                        point.y = Double(self.points[currentPointNum].location.y / imageHeight)
                        point.objectWillChange.send()
                        photo.objectWillChange.send()
                        try? viewContext.save()
                        self.isChangingPoint = false
                        print("Changed point: \(point)")
                    }
                } else {
                    return
                }
            }
        }
    }
    
    private func addPoint() {
        withAnimation {
            self.points.append(newPoint)
            let point = Point(context: viewContext)
            Point.createPoint(point, pointVM: self.newPoint, x: Double(self.newPoint.location.x / imageWidth), y: Double(self.newPoint.location.y / imageHeight), photo: self.photo)
            self.isAddingPoint = false
            self.newPoint = PointVM()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deletePoint() {
        withAnimation {
            if let points = photo.points {
                points.forEach { point in
                    if let point = point as? Point {
                        if point.id!.uuidString == self.points[currentPointNum].id.uuidString {
                            viewContext.delete(point)
                            photo.objectWillChange.send()
                            try? viewContext.save()
                            self.isChangingPoint = false
                            print("Deleted point")
                            return
                        }
                    } else {
                        return
                    }
                }
            }
        }
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
