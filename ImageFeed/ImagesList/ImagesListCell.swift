//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 09.09.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell {
      
    // MARK: - IBOutlets

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties

    static let reuseIdentifier: String = "ImagesListCell"
    
}
