//
//  StoryCardView.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 7/6/23.
//

import SwiftUI

struct StoryCardView: View {
    @Binding var bundle: StoryBundle
    @EnvironmentObject var storyData: StoryViewModel
    @State private var timerProgress: CGFloat = 0
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let story = getCurrentStory() {
                    Image(story.imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: proxy.size.width * 16 / 9)
                        .clipped()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width < 0 {
                            // Swiped left
                            updateStory(forward: true)
                        } else if value.translation.width > 0 {
                            // Swiped right
                            updateStory(forward: false)
                        }
                    }
            )
            .onTapGesture {
                if timerProgress + 1 > CGFloat(bundle.stories.count) {
                    updateStory(forward: true)
                } else {
                    timerProgress += 1
                }
            }
            .overlay(
                VStack {
                    HStack {
                        Image(bundle.profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                        
                        Text(bundle.profileName)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                storyData.showStory = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                    HStack(spacing: 5) {
                        ForEach(bundle.stories.indices) { index in
                            Capsule()
                                .fill(Color.gray.opacity(0.5))
                                .overlay(
                                    Capsule()
                                        .fill(Color.white)
                                        .frame(width: proxy.size.width / CGFloat(bundle.stories.count) * CGFloat(min(max(timerProgress - CGFloat(index), 0), 1)))
                                )
                        }
                    }
                    .frame(height: 1.4)
                    .padding(.horizontal)
                    
                }
                .padding(.top, proxy.safeAreaInsets.top)
                , alignment: .top
            )
            .rotation3DEffect(
                getAngle(proxy: proxy),
                axis: (x: 0, y: 1, z: 0),
                anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                perspective: 2.5
            )
            .onReceive(timer) { _ in
                if storyData.currentStory == bundle.id {
                    if !bundle.isSeen {
                        bundle.isSeen = true
                    }
                    
                    if timerProgress < CGFloat(bundle.stories.count) {
                        if getAngle(proxy: proxy).degrees == 0 {
                            timerProgress += 0.03
                        }
                    } else {
                        updateStory()
                    }
                }
            }
        }
        .onAppear {
            timerProgress = 0
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            timer.upstream.connect().cancel()
        }

    }
    

    
    // Updating On End
    func updateStory(forward: Bool = true) {
        let index = min(Int(timerProgress), bundle.stories.count - 1)
        let currentStory = bundle.stories[index]
        
        if forward {
            if let nextStory = bundle.stories[safe: index + 1] {
                withAnimation {
                    storyData.currentStory = nextStory.id
                }
            } else {
                withAnimation {
                    storyData.showStory = false
                }
            }
        } else {
            if let previousStory = bundle.stories[safe: index - 1] {
                withAnimation {
                    storyData.currentStory = previousStory.id
                }
            } else {
                timerProgress = 0
            }
        }
    }
    
    func getAngle(proxy: GeometryProxy) -> Angle {
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        let rotationAngle: CGFloat = 45
        let degrees = rotationAngle * progress
        return Angle(degrees: Double(degrees))
    }
    
    func getCurrentStory() -> Story? {
        let index = min(Int(timerProgress), bundle.stories.count - 1)
        return bundle.stories[safe: index]
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
