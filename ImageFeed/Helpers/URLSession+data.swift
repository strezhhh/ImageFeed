//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import Foundation
import Logging

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
    case codeError
    case tokenMissing
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    Apploger.error("URLSession.data: HTTP ошибка: \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                Apploger.error("URLSession.data: HTTP ошибка", error)
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                Apploger.error("запрос не удалось выполнить")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}

// Теперь функция, создающая URLSessionTask, может декодировать успешный ответ сервера в Decodable-объект
extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let response = try decoder.decode(T.self, from: data)
                    completion(.success(response))
                } catch {
                    Apploger.error("Ошибка декодирования. Данные: \(String(data: data, encoding: .utf8) ?? "")", error)
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                switch error {
                case NetworkError.httpStatusCode(let statusCode):
                    Apploger.error("HTTP ошибка: \(statusCode)")
                case NetworkError.urlRequestError(let requestError):
                    Apploger.error("HTTP ошибка: \(requestError)")
                case NetworkError.urlSessionError:
                    Apploger.error("запрос не удалось выполнить")
                default:
                    Apploger.error("HTTP ошибка")
                }
                completion(.failure(error))
            }
        }
        return task
    }
}
