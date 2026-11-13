//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import Foundation
import Logging

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    // MARK: - Properties
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    
    private let decoder = JSONDecoder()
    private var session = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Initialization
    private init() {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: conf)
    }
    
    // MARK: - Methods
    
    // Make a POST URLrequest to https://unsplash.com/oauth/token
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        guard let request = makeRequestOAuthToken(code: code) else {
            Apploger.error("ошибка создания экземпляра реквеста")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.bearerToken))
            case .failure(let error):
                Apploger.error("ошибка получения bearerToken", error)
                completion(.failure(error))
            }
            self?.task = nil
            self?.lastCode = nil
        }
        task?.resume()
        
    }
    
    // MARK: - Private Methods
    
    // prepare a POST URLrequest to https://unsplash.com/oauth/token
    private func makeRequestOAuthToken(code: String) -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: ConstantsValue.postRequestOAuthTokenURLString)
                else {
            Apploger.error("ошибка создания URLComponents из строки:  \(ConstantsValue.postRequestOAuthTokenURLString)")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsName.clientID, value: ConstantsValue.accessKey),
            URLQueryItem(name: ConstantsName.clientSecret, value: ConstantsValue.secretKey),
            URLQueryItem(name: ConstantsName.redirectURI, value: ConstantsValue.redirectURI),
            URLQueryItem(name: ConstantsName.codeString, value: code),
            URLQueryItem(name: ConstantsName.grantType, value: ConstantsValue.grantType)
        ]
        guard
            let urlOAuthToken = urlComponents.url
                else {
            Apploger.error("ошибка создания URL из URLComponents")
            return nil
        }
        var request = URLRequest(url: urlOAuthToken)
        request.httpMethod = ConstantsValue.requestMethodPost
        return request
    }
    
}
