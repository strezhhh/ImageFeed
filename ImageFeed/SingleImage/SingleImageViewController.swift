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
            guard
                isViewLoaded,
                let image = image else { return }
            singleImageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
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
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // Метод установит минимальное и максимально значение для зума
    private func setupScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    // Метод пропоруионально растянет/сожмет изображение до размеров экрана и выровнит изображение по центру
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
    
    // Метод будет центровать изображение сразу после зума
    private func centerImageAfterZoom(image: UIImage) {
        let visibleRectSize = scrollView.bounds.size
        let newContentSize = scrollView.contentSize
        
        let verticalInset = max ( 0, ( visibleRectSize.height - newContentSize.height ) / 2 )
        let horizontalInset = max ( 0, ( visibleRectSize.width - newContentSize.width ) / 2 )
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
    
    // Метод покажет стандартное меню "Поделиться"
    private func didTapShareButton() {
        guard let image = singleImageView.image else { return }
        let shareImage = UIActivityViewController (
            activityItems: [image],
            applicationActivities: nil
        )
        present(shareImage, animated: true)
    }
    
    
    // MARK: - IBActions
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        didTapShareButton()
    }
    
    
}

// MARK: - Extension SingleImageViewController: UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageView
    }
    
    func scrollViewDidZoom(_ : UIScrollView) {
        guard let image = singleImageView.image else { return }
        centerImageAfterZoom(image: image)
    }
}
