//
//  File.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 26.11.2026.
//

import UIKit

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let welcomeDescription: String?
    let urls: UrlsResult
    let isLiked: Bool
    
    var size: CGSize {
        CGSize(width: width, height: height)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, width, height, urls
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
    }
}
