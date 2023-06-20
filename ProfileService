//
//  ProfileService.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/16/23.
//

import Foundation
import Firebase

class ProfileService: ObservableObject {
    @Published var posts: [PostModel] = []
    @Published var following = 0
    @Published var followers = 0
    
    static var following = AuthService.storeRoot.collection("following")
    static var followers = AuthService.storeRoot.collection("followers")
    
    static func followingCollection(userId: String) -> CollectionReference {
        return following.document(userId).collection("following")
    }
    
    static func followersCollection(userId: String) -> CollectionReference {
        return followers.document(userId).collection("followers")
    }
    
    func loadUserPosts(userId: String) {
        PostService.loadUserPosts(userId: userId) { posts in
            self.posts = posts
        }
        
        follows(userId: userId)
        followers(userId: userId)
    }
    
    func follows(userId: String) {
        ProfileService.followingCollection(userId: userId).getDocuments { querySnapshot, _ in
            if let documents = querySnapshot?.documents {
                self.following = documents.count
            }
        }
    }
    
    func followers(userId: String) {
        ProfileService.followersCollection(userId: userId).getDocuments { querySnapshot, _ in
            if let documents = querySnapshot?.documents {
                self.followers = documents.count
            }
        }
    }
}

