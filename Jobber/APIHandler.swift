//
//  APIHandler.swift
//  Jobber
//
//  Created by Matteo on 07/04/2022.
//

import Foundation

enum JobsURL {
    static var accessToken = "https://entreprise.pole-emploi.fr/connexion/oauth2/access_token?realm=/partenaire"
    static var jobs = "https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search"
}

protocol APIHandling {
    func fetchAccessToken(completion: ((Result<String, NetworkError>) -> Void)?)
    func fetchJobs(token: String, queryParams: String, completion: ((Result<Jobs, NetworkError>) -> Void)?)
}

class APIHandler: APIHandling {
    
    let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchAccessToken(completion: ((Result<String, NetworkError>) -> Void)?) {
        
        let postString = "grant_type=\(Credentials.grant_type)&client_id=\(Credentials.client_id)&client_secret=\(Credentials.client_secret)&scope=\(Credentials.scope)"
        
        let url = URL(string: JobsURL.accessToken)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        networkManager.data(from: request , type: Access.self) { result in
            switch result {
                case .success(let data):
                    guard let completion = completion else {
                        return
                    }
                    completion(.success(data.access_token))
                case .failure(let err):
                    guard let completion = completion else {
                        return
                    }
                    completion(.failure(err))
            }
        }
    }
    
    func fetchJobs(token: String, queryParams: String, completion: ((Result<Jobs, NetworkError>) -> Void)?) {
        
        guard let url = URL(string: JobsURL.jobs + queryParams) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        networkManager.data(from: request, type: Jobs.self) { result in
            switch result {
                case .success(let data):
                    guard let completion = completion else {
                        return
                    }
                    completion(.success(data))
                case .failure(let err):
                    guard let completion = completion else {
                        return
                    }
                    completion(.failure(err))
            }
        }
    }
}
