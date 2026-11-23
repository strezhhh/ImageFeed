//
//  ViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 05.09.2026.
//

import UIKit
import Logging
import Kingfisher


final class ImagesListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private let photosName: [String] = Array(0...19).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // переменная хранит название мокового ресурса
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // обсервер
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private var imagesListService = ImagesListService()
    var photos: [Photo] = []
    private let placeholderIcon = "placeholderIcon"
    
    private let alertPresenter = AlertPresenter.shared

    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
        setupTableView()
        imagesListService.fetchPhotosNextPage()
    }
    
    
    // MARK: - Private Methods
    
    /*private*/ func setIsLiked(_ like: Bool, cell: ImagesListCell){
        if like {
            cell.likeButton.setImage(UIImage(resource: .active), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(resource: .noActive), for: .normal)
        }
    }
    
    // Присваиваем обсервер, возвращаемый функцией addObserver
    private func setupObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { index in
                    IndexPath(row: index, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
        
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    // MARK: - Override Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
                    else {
                Applogger.error("Ошибка перехода по segue: showSingleImageSegueIdentifier")
                assertionFailure("ImagesListViewController.prepare: Ошибка перехода по segue: showSingleImageSegueIdentifier")
                return
            }
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - ImagesListViewController

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with photo: Photo) {
        
        guard let imageUrl = URL(string: photo.thumbImageURL) else {
            Applogger.error("Ошибка создания URL")
            return
        }
        cell.imageCell.contentMode = .center
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(with: imageUrl,
                                   placeholder: UIImage(named: placeholderIcon),
                                   options: [
                                   ]) { result in
                                       switch result {
                                       case .success(_):
                                           cell.imageCell.contentMode = .scaleAspectFill
                                           if let index = self.tableView.indexPath(for: cell) {
                                               if self.photos[index.row].id == photo.id {
                                                   self.tableView.reloadRows(at: [index], with: .automatic)
                                               }
                                           }
                                       case .failure(let error):
                                           Applogger.error("ошибка создания экземпляра реквеста: \(error.localizedDescription)")
                                       }
                                   }
        cell.dateLabel.text = ""
        if let createdAt = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdAt)
        }
        setIsLiked(photo.isLiked, cell: cell)
    }
    
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: photos[indexPath.row])
        imageListCell.delegate = self
        return imageListCell
    }
    
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let photoSize = photos[indexPath.row].size
        let imageWidth = photoSize.width
        guard imageWidth != 0 else {
            return 0
        }
        let scale = imageViewWidth / imageWidth
        let cellHeight = photoSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        // TODO
        guard let indexPath = tableView.indexPath(for: cell) else {
            Applogger.error("ошибка обращения к индексу ячейки")
            return
        }
        UIBlockingProgressHUD.show()

        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else {
                UIBlockingProgressHUD.dismiss()
                return
            }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                self.setIsLiked(self.photos[indexPath.row].isLiked, cell: cell)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                Applogger.error("Не получилось поменять статус лайка")
                self.alertPresenter.showAlertWithMessage(viewController: self, title: "Что-то пошло не так", message: "Не удалось поставить или снять лайк", buttonText: "Ok") {
                }
            }
        }
    }
}

