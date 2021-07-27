//
//  OnboardingView.swift
//  Storager
//
//  Created by Evader on 27/7/21.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("walkthroughPage") var currentPage = 1
    let totalPages = 3

    var body: some View {
        ZStack {
            if currentPage == 1 {
                OnboardingSubView(imageString: "Walkthrough1", title: "Pick an image", description: "Take a photo of the items that your want to keep track of", bgColor: Color("Color1"))
                    .transition(.scale)
            }
            if currentPage == 2 {
                OnboardingSubView(imageString: "Walkthrough2", title: "Mark your items", description: "Just tap your items on the image, and its location will be memorized.", bgColor: Color("Color1"))
                    .transition(.scale)
            }
            if currentPage == 3 {
                OnboardingSubView(imageString: "Walkthrough3", title: "Search", description: "Easily find your items by keying its name", bgColor: Color("Color1"))
                    .transition(.scale)
            }
        }
        .overlay(
            Button(action: {
                withAnimation(.easeInOut) {
                    if currentPage <= totalPages {
                        currentPage += 1
                    }
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.black.opacity(0.04), lineWidth: 4)
                            Circle()
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                .stroke(Color.white, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                        .padding(-15)
                    )
            })
            .padding(.bottom, 20)
            ,alignment: .bottom
        )
    }
}

struct OnboardingSubView: View {
    @AppStorage("walkthroughPage") var currentPage = 1
    
    var imageString: String
    var title: String
    var description: String
    var bgColor: Color
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    if currentPage == 1 {
                        Text("User Guideline")
                            .font(.headline)
                            .padding(.horizontal)
                    } else {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                currentPage -= 1
                            }
                        }, label: {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.horizontal)
                        })
                    }
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            currentPage = 4
                        }
                    }, label: {
                        Text("Skip")
                            .font(.headline)
                            .padding(.horizontal)
                    })
                }
                HStack {
                    Image(imageString)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 0.9 * geo.size.width)
                        .cornerRadius(20)
                }
                .frame(width: geo.size.width)
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding(.top)
                Text(description)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    
                Spacer()
            }
            .background(bgColor.ignoresSafeArea())
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
