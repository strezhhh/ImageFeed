//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 22.10.2026.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username, bio
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
}

final class ProfileService {
    
    // MARK: - Private Properties
    
    private var session: URLSession
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    
    // MARK: - Initialization
    
    init () {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: conf)
    }
    
    
    // MARK: - Methods
    
    // Метод создаст GET-запрос личной информации профиля пользователя по адресу "https://api.unsplash.com/me"
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        self.task?.cancel()
        
        guard let request = makeRequestProfile(bearer: token)
                else {
            print("ProfileService.fetchProfile: ошибка создания экземпляра реквеста из метода makeRequestProfile(bearer...)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = session.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let profileResult = try self?.decoder.decode(ProfileResult.self, from: data)
                    let profile = Profile (
                        username: profileResult?.username ?? "username отсутствует",
                        name: "\(profileResult?.firstName ?? "") \(profileResult?.lastName ?? "")",
                        loginName: "@\(profileResult?.username ?? "")",
                        bio: profileResult?.bio
                    )
                    completion(.success(profile))
                } catch {
                    print("ProfileService.fetchProfile: ошибка декодирования JSON: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                switch error {
                case NetworkError.httpStatusCode(let statusCode):
                    print("ProfileService.fetchProfile: HTTP ошибка: \(statusCode)")
                case NetworkError.urlRequestError(let requestError):
                    print("ProfileService.fetchProfile: HTTP ошибка: \(requestError)")
                case NetworkError.urlSessionError:
                    print("ProfileService.fetchProfile: запрос не удалось выполнить")
                default:
                    print("ProfileService.fetchProfile: HTTP ошибка")
                }
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeRequestProfile(bearer token: String) -> URLRequest? {
        guard
            let url = URL(string: ConstantsValue.getRequestProfileDetails)
                else {
            print("ProfileService.makeRequestProfile: ошибка создания url из строки:  \(ConstantsValue.getRequestProfileDetails)")
            assertionFailure("ProfileService.makeRequestProfile: ошибка создания url из строки:  \(ConstantsValue.getRequestProfileDetails)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = ConstantsValue.requestMethodGET
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}

