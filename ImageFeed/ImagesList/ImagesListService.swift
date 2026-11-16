//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 15.11.2026.
//

import UIKit
import Logging

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: Date?
    let width: Int
    let height: Int
    let welcomeDescription: String?
    let urls: UrlsResult
    let isLiked: Bool
    
    var size: CGSize {
        CGSize(width: width, height: height)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, width, height, urls
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Decodable {
    let thumbImageURL: String
    let largeImageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "raw"
    }
}

final class ImagesListService {
    
    // MARK: - Static Properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var nextPage: Int?
    private let decoder = JSONDecoder()
    private var session = URLSession.shared
    private var task: URLSessionTask?
    
    
    // MARK: - Lifecycle
    init () {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: conf)
    }
    
    
    
    // MARK: - Methods
    
    func fetchPhotosNextPage() {
        
        guard task == nil else {
            Apploger.error("Запрос уже выполняется")
            return
        }
        
        guard let token = OAuth2TokenStorage.shared.token else {
            Apploger.error("ошибка, отсутствует bearerToken")
            return
        }
        
        nextPage = (self.lastLoadedPage ?? 0) + 1
        
        guard let nextPage else {
            Apploger.error("Отстуствует nextPage")
            return
        }
        
        guard let request = makeRequestNextPages(for: nextPage, bearer: token) else {
            Apploger.error("ошибка создания экземпляра реквеста")
            return
        }
        
        task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResult):
                guard let self else {
                    Apploger.error("Self отсутствует")
                    return
                }
                    for item in photoResult {
                        let photo = Photo(
                            id: item.id,
                            size: item.size,
                            createdAt: item.createdAt,
                            welcomeDescription: item.welcomeDescription,
                            thumbImageURL: item.urls.thumbImageURL,
                            largeImageURL: item.urls.largeImageURL,
                            isLiked: item.isLiked
                        )
                        self.photos.append(photo)
                    }
                    self.notifyAboutChanges()
                    self.lastLoadedPage = self.nextPage
                
            case .failure(let error):
                Apploger.error("ошибка получения bearerToken", error)
            }
            self?.task = nil
        }
        
        task?.resume()
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
            Apploger.error("ошибка создания URLComponents из строки:  \(ConstantsValue.getRequestPhotosNextPages)")
            assertionFailure("ImagesListService.makeRequestPhotosNextPages: ошибка создания URLComponents из строки:  \(ConstantsValue.getRequestPhotosNextPages)")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsName.page, value: "\(nextPage)"),
            URLQueryItem(name: ConstantsName.perPage, value: "\(ConstantsValue.defaultPerPage)")
        ]
        guard let URLNextPages = urlComponents.url else {
            Apploger.error("ошибка создания URL из urlComponents")
            return nil
        }
        var request = URLRequest(url: URLNextPages)
        request.httpMethod = ConstantsValue.requestMethodGET
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // ЭТО НАДО ????
        
        return request
    }
    
}


