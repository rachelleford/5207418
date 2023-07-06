//
//  StoryHome.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 7/5/23.

//

import SwiftUI

struct StoryHome: View {
    @StateObject var storyData = StoryViewModel()
    @State private var selectedStoryIndex: Int?

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Button(action: {
                                // Button action
                            }) {
                                Image("boss1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .overlay(
                                        Image(systemName: "plus")
                                            .padding(7)
                                            .background(Color.red, in: Circle())
                                            .foregroundColor(.white)
                                            .padding(2)
                                            .background(Color.black, in: Circle())
                                            .offset(x: 10, y: 10)
                                    )
                            }
                            .padding(.trailing, 10)

                            ForEach(storyData.stories.indices, id: \.self) { index in
                                ProfileView(bundle: $storyData.stories[index])
                                    .environmentObject(storyData)
                                    .onTapGesture {
                                        selectedStoryIndex = index
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    .padding(.top, -10) // Adjust the top padding of the horizontal ScrollView

                    Divider()
                        .padding(.top, 10) // Adjust the top padding of the divider
                }

                if let selectedStoryIndex = selectedStoryIndex {
                    StoryCardView(bundle: $storyData.stories[selectedStoryIndex])
                        .environmentObject(storyData)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.opacity)
                        .zIndex(1)
                        .onDisappear {
                            storyData.stories[selectedStoryIndex].isSeen = true
                            self.selectedStoryIndex = nil
                        }
                }
            }
            .background(Color.red) // Set the background color of the entire view
            .navigationBarHidden(true)
      //      .padding(.bottom, 140)
        }
    }
}
