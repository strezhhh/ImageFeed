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
        guard let image = image else { return }
        rescaleAndCenterImageInScrollView(image: image)
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
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension SingleImageViewController: UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Scroll happened")
    }
}
