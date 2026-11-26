//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 15.11.2026.
//

import UIKit
import Logging

final class ImagesListService {
    
    // MARK: - Static Properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var session: URLSession
    private var taskForNextPage: URLSessionTask?
    private var taskForLike: URLSessionTask?
    
    // MARK: - Lifecycle
    init () {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Methods
    
    func cleanPhotos() {
        photos.removeAll()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token else {
            Applogger.error("ошибка, отсутствует bearerToken")
            completion(.failure(NetworkError.tokenMissing))
            return
        }
        guard let request = makeRequestLike(
            id: photoId,
            bearer: token,
            like: isLike
        ) else {
            Applogger.error("ошибка создания экземпляра реквеста из метода makeRequestLike()")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        taskForLike = session.data(for: request) { [weak self] (result: Result<Data, Error>) in
            switch result {
            case .success:
                guard
                    let self,
                    let index = self.photos.firstIndex(where: { $0.id == photoId })
                        else {
                    Applogger.error("ошибка выполнения условий")
                    completion(.failure(NetworkError.invalidRequest))
                    return
                }
                let photo = self.photos[index]
                let newPhoto = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: !photo.isLiked
                )
                self.photos[index] = newPhoto
                
                completion(.success(()))
            case .failure(let error):
                Applogger.error("ошибка лайка/дизлайка", error)
                completion(.failure(error))
            }
        }
        taskForLike?.resume()
        
    }
    
    func fetchPhotosNextPage() {
        guard taskForNextPage == nil else {
            Applogger.error("Запрос уже выполняется")
            return
        }
        guard let token = OAuth2TokenStorage.shared.token else {
            Applogger.error("ошибка, отсутствует bearerToken")
            return
        }
        let nextPage = (self.lastLoadedPage ?? 0) + 1
        
        guard let request = makeRequestNextPages(for: nextPage, bearer: token) else {
            Applogger.error("ошибка создания экземпляра реквеста")
            return
        }
        taskForNextPage = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResult):
                guard let self else {
                    Applogger.error("Self отсутствует")
                    return
                }
                let newPhoto = photoResult.map { Photo(result: $0) }
                self.photos.append(contentsOf: newPhoto)
                self.notifyAboutChanges()
                self.lastLoadedPage = nextPage
                
            case .failure(let error):
                Applogger.error("ошибка получения bearerToken", error)
            }
            self?.taskForNextPage = nil
        }
        taskForNextPage?.resume()
    }
    
    // MARK: - Private Methods
    
    private func notifyAboutChanges() {
        NotificationCenter.default
            .post(
                name: ImagesListService.didChangeNotification,
                object: self)
    }
    
    private func makeRequestNextPages(for nextPage: Int, bearer token: String) -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: ConstantsValue.getRequestPhotosNextPages)
                else {
            Applogger.error("ошибка создания URLComponents из строки:  \(ConstantsValue.getRequestPhotosNextPages)")
            assertionFailure("ImagesListService.makeRequestPhotosNextPages: ошибка создания URLComponents из строки:  \(ConstantsValue.getRequestPhotosNextPages)")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsName.page, value: "\(nextPage)"),
            URLQueryItem(name: ConstantsName.perPage, value: "\(ConstantsValue.defaultPerPage)")
        ]
        guard let URLNextPages = urlComponents.url else {
            Applogger.error("ошибка создания URL из urlComponents")
            return nil
        }
        var request = URLRequest(url: URLNextPages)
        request.httpMethod = ConstantsValue.requestMethodGET
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // ЭТО НАДО ????
        
        return request
    }
    
    
    private func makeRequestLike(id: String, bearer token: String, like: Bool) -> URLRequest? {
        guard
            let url = URL(string: ConstantsValue.getRequestIsLike(photoID: id))
                else {
            Applogger.error("ошибка создания URL из строки:  \(ConstantsValue.getRequestIsLike(photoID: id))")
            return nil
        }
        var request = URLRequest(url: url)
        if like {
            request.httpMethod = ConstantsValue.requestMethodPost
        }
        else {
            request.httpMethod = ConstantsValue.requestMethodDelete
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
}


