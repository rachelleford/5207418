//
//  StorageService.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/16/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class StorageService {
    static let storage = Storage.storage()
    static let storageRoot = storage.reference()
    static let storageProfile = storageRoot.child("profile")
    static let storagePost = storageRoot.child("post")
    
    static func storagePostId(postId: String) -> StorageReference {
        return storagePost.child(postId)
    }
    
    static func storageProfileId(userId: String) -> StorageReference {
        return storageProfile.child(userId)
    }
    
    static func editProfile(userId: String, username: String, bio: String, imageData: Data, website: String, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onError: @escaping (_ errorMessage: String) -> Void) {
        
        storageProfileImageRef.putData(imageData, metadata: metaData) { (storageMetadata, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            storageProfileImageRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges { (error) in
                            if let error = error {
                                onError(error.localizedDescription)
                                return
                            }
                        }
                    }
                    
                    let firestoreUserId = AuthService.getUserId(userId: userId)
                    
                    firestoreUserId.updateData([
                        "profileImageUrl": metaImageUrl,
                        "username": username,
                        "bio": bio,
                        "website": website
                    ])
                }
            }
        }
    }
    
    static func saveProfileImage(userId: String, username: String, email: String, imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onSuccess: @escaping (_ user: User) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        storageProfileImageRef.putData(imageData, metadata: metaData) { (storageMetadata, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            storageProfileImageRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges { (error) in
                            if let error = error {
                                onError(error.localizedDescription)
                                return
                            }
                        }
                    }
                    
                    let firestoreUserId = AuthService.getUserId(userId: userId)
                    let user = User(id: "", uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, searchName: username.splitString(), bio: "", website: "", isVerified: false)
                    // Modify the `isVerified` value based on your logic
                    
                    guard let dict = try? user.asDictionary() else {
                        return
                    }
                    
                    firestoreUserId.setData(dict) { (error) in
                        if let error = error {
                            onError(error.localizedDescription)
                        }
                    }
                    
                    onSuccess(user)
                }
            }
        }
    }
    
    static func savePostPhoto(userId: String, caption: String, postId: String, imageData: Data, metadata: StorageMetadata, storagePostRef: StorageReference, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        storagePostRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            storagePostRef.downloadURL { (url, error) in
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                if let metaImageUrl = url?.absoluteString {
                    let firestorePostRef = PostService.PostsUserId(userId: userId).collection("posts").document(postId)
                    
                    let user = User(
                        id: "", uid: userId,
                        email: "", // Provide the user's email here
                        profileImageUrl: Auth.auth().currentUser!.photoURL!.absoluteString,
                        username: Auth.auth().currentUser!.displayName!,
                        searchName: [], // Provide the user's searchName here
                        bio: "", // Provide the user's bio here
                        website: "", // Provide the user's website here
                        isVerified: false // Provide the user's verification status here
                    )
                    
                    let post = PostModel(
                        id: postId,
                        title: "",
                        time: Date(),
                        user: user, // Pass the user instance instead of UserViewModel()
                        caption: caption,
                        likes: [:],
                        geoLocation: "",
                        ownerId: userId,
                        postId: postId,
                        username: Auth.auth().currentUser!.displayName!,
                        profile: Auth.auth().currentUser!.photoURL!.absoluteString,
                        mediaUrl: metaImageUrl,
                        date: Date().timeIntervalSince1970,
                        likeCount: 0,
                        isVerified: false
                    )
                    
                    guard let dict = try? post.asDictionary() else { return }
                    
                    firestorePostRef.setData(dict) { (error) in
                        if let error = error {
                            onError(error.localizedDescription)
                            return
                        }
                        
                        PostService.timelineUserId(userId: userId).collection("timeline").document(postId).setData(dict)
                        PostService.AllPosts.document(postId).setData(dict)
                        
                        onSuccess()
                    }
                } else {
                    onError("Failed to get image URL.")
                }
            }
        }
    }
}
