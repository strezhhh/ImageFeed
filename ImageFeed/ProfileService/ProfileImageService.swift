//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 30.10.2026.
//

import Foundation
import Logging

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
    
}


final class ProfileImageService {
    
    // MARK: - Shared Properties
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    
    // сюда проставим profile_image в случае успешного запроса
    private(set) var avatarURL: String?
    
    private var session: URLSession
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    
    // MARK: - Initialization
    
    private init () {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: conf)
    }
    
    // MARK: - Methods
    
    // Метод создаст GET-запрос личной информации профиля пользователя по адресу "https://api.unsplash.com/users/:username"
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        self.task?.cancel()
        
        guard let token = OAuth2TokenStorage.shared.token else {
            Apploger.error("ошибка, отсутствует bearerToken")
            completion(.failure(NetworkError.tokenMissing))
            return
        }
        
        guard let request = makeRequestProfileImage(username, bearer: token)
                else {
            Apploger.error("ошибка создания экземпляра реквеста из метода makeRequestProfileImage()")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    ProfileImageService.shared.avatarURL = result.profileImage.small
                    guard let profileImageURL = ProfileImageService.shared.avatarURL else {
                        Apploger.error("ошибка создания URL аватарки")
                        completion(.failure(NetworkError.invalidRequest))
                        return
                    }
                    completion(.success(profileImageURL))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profileImageURL])
                case .failure(let error):
                    Apploger.error("ошибка получения URL аватара профиля", error)
                    completion(.failure(error))
                }
                self?.task = nil
            }
        }
        task?.resume()
    }
    
    
    // MARK: - Private Methods
    
    private func makeRequestProfileImage(_ username: String, bearer token: String) -> URLRequest? {
        guard
            let url = URL(string: "\(ConstantsValue.getRequestProfileImage)\(username)")
                else {
            Apploger.error("ошибка создания url из строки:  \(ConstantsValue.getRequestProfileImage)")
            assertionFailure("ProfileService.makeRequestProfileImage: ошибка создания url из строки:  \(ConstantsValue.getRequestProfileImage)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = ConstantsValue.requestMethodGET
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
