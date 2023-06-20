//
//  User.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/16/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    var id: String
    var uid: String
    var email: String
    var profileImageUrl: String
    var username: String
    var searchName: [String]
    var bio: String
    var website: String
    var isVerified: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case profileImageUrl
        case username
        case searchName
        case bio
        case website
        case isVerified
    }
    
    // Update the constructor to include the 'id' parameter
    init(id: String, uid: String, email: String, profileImageUrl: String, username: String, searchName: [String], bio: String, website: String, isVerified: Bool? = nil) {
        self.id = id
        self.uid = uid
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.username = username
        self.searchName = searchName
        self.bio = bio
        self.website = website
        self.isVerified = isVerified
    }
    
    // Add the 'init' method to conform to the 'Decodable' protocol
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.email = try container.decode(String.self, forKey: .email)
        self.profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
        self.username = try container.decode(String.self, forKey: .username)
        self.searchName = try container.decode([String].self, forKey: .searchName)
        self.bio = try container.decode(String.self, forKey: .bio)
        self.website = try container.decode(String.self, forKey: .website)
        self.isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified)
    }
    
    // Add the 'encode' method to conform to the 'Encodable' protocol
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(uid, forKey: .uid)
        try container.encode(email, forKey: .email)
        try container.encode(profileImageUrl, forKey: .profileImageUrl)
        try container.encode(username, forKey: .username)
        try container.encode(searchName, forKey: .searchName)
        try container.encode(bio, forKey: .bio)
        try container.encode(website, forKey: .website)
        try container.encode(isVerified, forKey: .isVerified)
    }
}

