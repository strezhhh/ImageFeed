//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 30.10.2026.
//

import Foundation

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
    
    private enum CodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }
}


final class ProfileImageService {
    
    // MARK: - Shared Properties
    
    static let shared = ProfileImageService()
    
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
            print("ProfileImageService.fetchProfileImageURL: ошибка, отсутствует bearer token")
            completion(.failure(NetworkError.tokenMissing))
            return
        }
        
        guard let request = makeRequestProfileImage(username, bearer: token)
                else {
            print("ProfileImageService.fetchProfileImageURL: ошибка создания экземпляра реквеста из метода makeRequestProfileImage()")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = session.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let userResult = try self?.decoder.decode(UserResult.self, from: data)
                    ProfileImageService.shared.avatarURL = userResult?.profileImage.small
                    guard let imageURL = userResult?.profileImage.small else {
                        print("ProfileImageService.fetchProfileImageURL: ошибка создания строки с url изображения")
                        return
                    }
                    completion(.success(imageURL))
                } catch {
                    print("ProfileImageService.fetchProfileImageURL: ошибка декодирования JSON: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                switch error {
                case NetworkError.httpStatusCode(let statusCode):
                    print("ProfileImageService.fetchProfileImageURL: HTTP ошибка: \(statusCode)")
                case NetworkError.urlRequestError(let requestError):
                    print("ProfileImageService.fetchProfileImageURL: HTTP ошибка: \(requestError)")
                case NetworkError.urlSessionError:
                    print("ProfileImageService.fetchProfileImageURL: запрос не удалось выполнить")
                default:
                    print("ProfileImageService.fetchProfileImageURL: HTTP ошибка")
                }
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    
    // MARK: - Private Methods
    
    private func makeRequestProfileImage(_ username: String, bearer token: String) -> URLRequest? {
        guard
            let url = URL(string: "\(ConstantsValue.getRequestProfileImage)\(username)")
                else {
            print("ProfileService.makeRequestProfileImage: ошибка создания url из строки:  \(ConstantsValue.getRequestProfileImage)")
            assertionFailure("ProfileService.makeRequestProfileImage: ошибка создания url из строки:  \(ConstantsValue.getRequestProfileImage)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = ConstantsValue.requestMethodGET
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
