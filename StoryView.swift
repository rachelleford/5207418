//
//  StoryView.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 7/5/23.
//

import SwiftUI

struct StoryView: View {
    @EnvironmentObject var storyData: StoryViewModel

    var body: some View {
        if storyData.showStory {
            // Remove NavigationView
            TabView(selection: $storyData.currentStory) {
                ForEach($storyData.stories) { $bundle in
                    NavigationLink(destination: StoryCardView(bundle: $bundle).environmentObject(storyData)) {
                        EmptyView()
                    }
                    .tabItem { EmptyView() }
                    .tag(bundle.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .transition(.move(edge: .bottom))
        }
    }
}


