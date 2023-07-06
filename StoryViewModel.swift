//
//  StoryViewModel.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 7/5/23.
//

import SwiftUI

class StoryViewModel: ObservableObject{
    
    // List of Stories...
    @Published var stories : [StoryBundle] = [
    
        StoryBundle(profileName: "Shiba Billionaire", profileImage: "boss1", stories: [
        
            Story(imageURL: "boss1"),
            Story(imageURL: "post2"),
            Story(imageURL: "post3"),
        ]),
        
        StoryBundle(profileName: "Jenna Ezarik", profileImage: "profile3", stories: [
        
            Story(imageURL: "post4"),
            Story(imageURL: "post5"),
        ]),
        
        StoryBundle(profileName: "Jenna Ezarik", profileImage: "profile4", stories: [
        
            Story(imageURL: "post4"),
            Story(imageURL: "post5"),
        ]),
        
        StoryBundle(profileName: "Jenna Ezarik", profileImage: "profile5", stories: [
        
            Story(imageURL: "post4"),
            Story(imageURL: "post5"),
        ]),
        
        StoryBundle(profileName: "Jenna Ezarik", profileImage: "profile6", stories: [
        
            Story(imageURL: "post4"),
            Story(imageURL: "post5"),
        ])
    ]
    
    // Properties...
    @Published var showStory: Bool = false
    // Will Be unique Story Bundle ID....
    @Published var currentStory: String = ""
}
