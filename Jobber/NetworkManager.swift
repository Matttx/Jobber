//
//  NetworkManager.swift
//  Jobber
//
//  Created by Matteo on 07/04/2022.
//

import Foundation

enum NetworkError: Error, Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
            case (.noData, .noData):
                return true
            case (let .error(error1), let error(error2)):
                return error1.localizedDescription == error2.localizedDescription
            case (.malformedData, .malformedData):
                return true
            default:
                return false
        }
    }
    
    case noData
    case error(Error)
    case malformedData
}

protocol NetworkManaging {
    func data<T: Decodable>(from url: URL, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
    func data<T: Decodable>(from url: URLRequest, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

public class NetworkManager: NetworkManaging {
    
    init() {
        
    }
    
    func data<T: Decodable>(from url: URL, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                if let data = try? JSONDecoder().decode(type, from: data) {
                    completion(.success(data))
                } else {
                    completion(.failure(.malformedData))
                }
            } else if let error = error  {
                completion(.failure(.error(error)))
            }
        }
        task.resume()
    }
    
    func data<T: Decodable>(from url: URLRequest, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                if let data = try? JSONDecoder().decode(type, from: data) {
                    completion(.success(data))
                } else {
                    completion(.failure(.malformedData))
                }
            } else if let error = error  {
                completion(.failure(.error(error)))
            }
        }
        task.resume()
    }
}
