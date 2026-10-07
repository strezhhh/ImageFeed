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

    
    // MARK: - Initialization
    private init() {}

    
    // MARK: - Private Enumeration
    private enum NetworkError: Error {
        case codeError
    }
    
    // MARK: - Methods
    
    // Make a POST URLrequest to https://unsplash.com/oauth/token
    func fetchOAuthToken(code: String) {
        guard let request = makeRequestOAuthToken(code: code) else {
            return
        }
        
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        let task = URLSession(configuration: conf).data(for: request) { result in
            switch result {
            case .success(let data):
                do {
//                    let oAuthTokenResponseBody = OAuthTokenResponseBody()
                    let response = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print(String(data: data, encoding: .utf8))
                   // handler(.success(mostPopularMovies))
                } catch {
                    print(error)

                    //handler(.failure(error))
                }
            case .failure(let error):
                print(error)
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private Methods

    // prepare a POST URLrequest to https://unsplash.com/oauth/token
    private func makeRequestOAuthToken(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: ConstantsValue.postRequestOAuthTokenURLString) else {
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
            return nil
        }
        var request = URLRequest(url: urlOAuthToken)
        request.httpMethod = ConstantsValue.requestMethod
        return request
    }


    
}
