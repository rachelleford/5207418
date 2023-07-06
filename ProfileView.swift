//
//  ProfileView.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 7/6/23.
//

import SwiftUI

struct ProfileView: View {
    @Binding var bundle: StoryBundle
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var storyData: StoryViewModel
    @State private var isShowingStoryCard = false

    var body: some View {
        Button(action: {
            withAnimation {
                storyData.currentStory = bundle.id
                isShowingStoryCard = true
            }
        }) {
            Image(bundle.profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(2)
                .background(colorScheme == .dark ? Color.black : Color.white, in: Circle())
                .padding(3)
                .background(
                    LinearGradient(colors: [.red, .orange, .red, .orange], startPoint: .top, endPoint: .bottom)
                        .clipShape(Circle())
                        .opacity(bundle.isSeen ? 0 : 1)
                )
        }
        .sheet(isPresented: $isShowingStoryCard) {
            NavigationView {
                StoryCardView(bundle: $bundle)
                    .environmentObject(storyData)
                    .navigationBarItems(trailing:
                        Button(action: {
                            isShowingStoryCard = false
                        }) {
                            Image(systemName: "xmark")
                        }
                    )
            }
        }
    }
}
