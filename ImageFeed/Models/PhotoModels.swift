//
//  File.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 26.11.2026.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
