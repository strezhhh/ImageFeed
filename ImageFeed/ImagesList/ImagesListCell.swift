//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 09.09.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Properties
    
    static let reuseIdentifier: String = "ImagesListCell"
    
}
