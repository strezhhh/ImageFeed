//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 22.11.2026.
//

import Foundation


protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
