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
    @IBOutlet private var scrollView: UIScrollView!
    
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
        setupSingleImageView()
        setupScrollView()
    }
    
    // MARK: - Private Methods
    
    private func setupSingleImageView() {
        guard let image else { return }
        singleImageView.image = image
        singleImageView.frame.size = image.size
    }
    
    private func setupScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    
    // MARK: - IBActions
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension ingleImageViewController: UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("Zoomable view")
        
        return singleImageView
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Scroll happened")
    }
}
