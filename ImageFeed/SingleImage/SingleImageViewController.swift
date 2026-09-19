//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 17.09.2026.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private var singleImageView: UIImageView!
    
    // MARK: - Properties

    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            singleImageView.image = image
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image
    }
    
    // MARK: - IBActions

    @IBAction func didTapBackButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
}
