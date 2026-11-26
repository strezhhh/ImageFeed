//
//  File.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 26.11.2026.
//

import Foundation

struct UrlsResult: Decodable {
    let thumbImageURL: String
    let largeImageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case thumbImageURL = "small"
        case largeImageURL = "full"
    }
}
