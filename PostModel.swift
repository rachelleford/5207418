//
//  PostModel.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/16/23.
//

import SwiftUI
import FirebaseFirestore

struct PostModel: Identifiable {
    var id: String
    var title: String
    var time: Date
    var user: User // Update this with your User struct
    var caption: String
    var likes: [String: Bool]
    var geoLocation: String
    var ownerId: String
    var postId: String
    var username: String
    var profile: String
    var mediaUrl: String
    var date: Double
    var likeCount: Int
    var isVerified: Bool // Add the isVerified property
    
    func asDictionary() throws -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "time": time,
            "user": try user.asDictionary(),
            "caption": caption,
            "likes": likes,
            "geoLocation": geoLocation,
            "ownerId": ownerId,
            "postId": postId,
            "username": username,
            "profile": profile,
            "mediaUrl": mediaUrl,
            "date": date,
            "likeCount": likeCount,
            "isVerified": isVerified // Include the isVerified property in the dictionary representation
        ]
    }
}
