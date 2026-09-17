//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 17.09.2026.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties

    var image: UIImage?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image
    }
    
    // MARK: - IBOutlets

    @IBOutlet private var singleImageView: UIImageView!

}
