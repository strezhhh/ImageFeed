//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 09.09.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var imageCell: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - Properties
    
    static let reuseIdentifier: String = "ImagesListCell"
    
}
