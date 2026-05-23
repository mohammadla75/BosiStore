//
//  Review.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation

struct Review: Identifiable, Codable, Equatable {
    var id: String
    var productId: String
    var userId: String
    var userName: String
    var rating: Int
    var comment: String
    var mediaItems: [MediaItem]
    var date: Date
    
    init(
        id: String = UUID().uuidString,
        productId: String,
        userId: String,
        userName: String,
        rating: Int,
        comment: String,
        mediaItems: [MediaItem] = [],
        date: Date = Date()
    ) {
        self.id = id
        self.productId = productId
        self.userId = userId
        self.userName = userName
        self.rating = rating
        self.comment = comment
        self.mediaItems = mediaItems
        self.date = date
    }
    
    static func == (lhs: Review, rhs: Review) -> Bool {
        lhs.id == rhs.id
    }
}

struct MediaItem: Identifiable, Codable, Equatable {
    var id: String
    var type: MediaType
    var localPath: String
    var thumbnailPath: String?
    
    init(
        id: String = UUID().uuidString,
        type: MediaType,
        localPath: String,
        thumbnailPath: String? = nil
    ) {
        self.id = id
        self.type = type
        self.localPath = localPath
        self.thumbnailPath = thumbnailPath
    }
}

enum MediaType: String, Codable {
    case photo
    case video
}
