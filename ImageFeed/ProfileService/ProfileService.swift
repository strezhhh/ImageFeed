//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 22.10.2026.
//

import Foundation
import Logging

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
    
    // MARK: - Shared Properties
    
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    
    private var session = URLSession.shared
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    private(set) var profile: Profile?

    
    // MARK: - Initialization
    
    private init () {
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
            Apploger.error("ошибка создания экземпляра реквеста из метода makeRequestProfile(bearer...)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    let profile = Profile (
                        username: result.username,
                        name: "\(result.firstName) \(result.lastName)",
                        loginName: "@\(result.username)",
                        bio: result.bio
                    )
                    ProfileService.shared.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    Apploger.error("ошибка получения данных профиля", error)
                    completion(.failure(error))
                }
                self?.task = nil
            }
        }
        task?.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeRequestProfile(bearer token: String) -> URLRequest? {
        guard
            let url = URL(string: ConstantsValue.getRequestProfileDetails)
                else {
            Apploger.error("ошибка создания url из строки:  \(ConstantsValue.getRequestProfileDetails)")
            assertionFailure("ProfileService.makeRequestProfile: ошибка создания url из строки:  \(ConstantsValue.getRequestProfileDetails)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = ConstantsValue.requestMethodGET
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}

