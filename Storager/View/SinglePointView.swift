//
//  SinglePointView.swift
//  Storager
//
//  Created by Evader on 13/7/21.
//

import SwiftUI

struct SinglePointView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var point: Point
    @State private var pointVM: PointVM = PointVM()
    @State private var isChangingPoint: Bool = false

    @GestureState private var dragState = DragState.inactive

    let imageHeight: CGFloat
    let imageWidth: CGFloat
    
    init(point: Point) {
        self.point = point
        self.imageWidth = UIScreen.main.bounds.width
        self.imageHeight = point.photo!.image.size.height * imageWidth / point.photo!.image.size.width
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: point.photo!.image)
                .resizable()
                .scaledToFit()
            ZStack {
                Circle()
                    .fill(pointVM.color)
                    .frame(width: 20, height: 20)
                    .position(x: pointVM.location.x, y: pointVM.location.y)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .updating($dragState) { drag, state, transaction in
                                state = .dragging(translation: drag.translation)
                            }
                            .onEnded { value in
                                self.isChangingPoint = true
                            }
                            .onChanged { value in
                                pointVM.location = CGPoint(x: value.location.x, y: value.location.y + imageHeight/2 - UIScreen.main.bounds.height/2)
                            }
                    )
            }
            .frame(width: self.imageWidth, height: self.imageHeight)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // initialize pointVM
            self.pointVM = PointVM(point: point, imageWidth: self.imageWidth, imageHeight: self.imageHeight)
        }
        // MARK: - Change point sheet
        .sheet(isPresented: $isChangingPoint) {
            NavigationView {
                VStack {
                    ZStack {
                        Image(uiImage: croppedImage(image: self.point.photo!.image))
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                        Circle()
                            .fill(self.pointVM.color)
                            .frame(width: 20, height: 20)
                    }
                    
                    TextField("Name", text: $pointVM.name)
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .multilineTextAlignment(.center)
                    
                    ColorPicker(selection: $pointVM.color) {
                        Text("Color")
                            .font(.headline)
                    }
                    .padding(EdgeInsets(top: 15, leading: 50, bottom: 20, trailing: 50))
                    
                    Button(action: deletePoint, label: {
                        Text("Delete")
                            .font(.headline)
                    })
                        .buttonStyle(DeleteButtonStyle())
                    
                    Spacer()
                }
                .navigationBarTitle("Edit Point")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button("Cancel") {
                    self.isChangingPoint = false
                }, trailing: Button("Done") {
                    changePoint()
                })
            }
        }
    }
    
    private func changePoint() {
        withAnimation {
            point.name = self.pointVM.name
            point.x = Double(self.pointVM.location.x / imageWidth)
            point.y = Double(self.pointVM.location.y / imageHeight)
            point.color = self.pointVM.color
            point.objectWillChange.send()
            try? viewContext.save()
            self.isChangingPoint = false
            print("Changed point: \(point)")
        }
    }
    
    private func deletePoint() {
        withAnimation {
            viewContext.delete(point)
            try? viewContext.save()
            self.isChangingPoint = false
            print("Deleted point")
            return
        }
    }
    
    private func croppedImage(image: UIImage) -> UIImage {
        let ratio = image.size.width / UIScreen.main.bounds.width
        var cgImage = image.cgImage!
    
        cgImage = cgImage.cropping(to: CGRect(origin: CGPoint(x: self.pointVM.location.x * ratio - image.size.width / 8, y: self.pointVM.location.y * ratio - image.size.width / 8), size: CGSize(width: image.size.width / 4, height: image.size.width / 4)))!
        return UIImage(cgImage: cgImage)
    }
}

//struct SinglePointView_Previews: PreviewProvider {
//    static var previews: some View {
//        SinglePointView()
//    }
//}
