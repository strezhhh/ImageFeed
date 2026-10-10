//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import Foundation

final class OAuth2Service {
    
    // MARK: - Properties
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    
    private let decoder = JSONDecoder()
    private var session: URLSession
    
    // MARK: - Initialization
    private init() {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: conf)
    }
    
    // MARK: - Methods
    
    // Make a POST URLrequest to https://unsplash.com/oauth/token
    func fetchOAuthToken(code: String, competition: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeRequestOAuthToken(code: code) else {
            print("OAuth2Service.fetchOAuthToken: ошибка создания экземпляра реквеста из метода makeRequestOAuthToken(...)")
            return
        }
        
        let task = session.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    competition(.success(response.bearerToken))
                } catch {
                    print("OAuth2Service.fetchOAuthToken: ошибка декодирования JSON c bearer token: \(error.localizedDescription). Передана в замыкание")
                    competition(.failure(error))
                }
            case .failure(let error):
                switch error {
                case NetworkError.httpStatusCode(let statusCode):
                    print("OAuth2Service: HTTP ошибка: \(statusCode)")
                case NetworkError.urlRequestError(let requestError):
                    print("OAuth2Service: HTTP ошибка: \(requestError)")
                case NetworkError.urlSessionError:
                    print("OAuth2Service: запрос не удалось выполнить")
                default:
                    print("OAuth2Service: HTTP ошибка")
                }
                
                competition(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private Methods
    
    // prepare a POST URLrequest to https://unsplash.com/oauth/token
    private func makeRequestOAuthToken(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: ConstantsValue.postRequestOAuthTokenURLString) else {
            print("OAuth2Service.makeRequestOAuthToken: ошибка создания URLComponents из строки:  \(ConstantsValue.postRequestOAuthTokenURLString)")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsName.clientID, value: ConstantsValue.accessKey),
            URLQueryItem(name: ConstantsName.clientSecret, value: ConstantsValue.secretKey),
            URLQueryItem(name: ConstantsName.redirectURI, value: ConstantsValue.redirectURI),
            URLQueryItem(name: ConstantsName.codeString, value: code),
            URLQueryItem(name: ConstantsName.grantType, value: ConstantsValue.grantType)
        ]
        guard let urlOAuthToken = urlComponents.url else {
            print("OAuth2Service.makeRequestOAuthToken: ошибка создания URL из URLComponents")
            return nil
        }
        var request = URLRequest(url: urlOAuthToken)
        request.httpMethod = ConstantsValue.requestMethod
        return request
    }
    
}
