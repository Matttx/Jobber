//
//  JobsViewModel.swift
//  Jobber
//
//  Created by Matteo on 07/04/2022.
//

import Foundation

class JobsViewModel: ObservableObject {
    
    @Published var jobs: [Job]?
    
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var isLoading: Bool = false
    
    @Published var keyword: String = ""
    
    private let apiHandler: APIHandling
    
    init(apiHandler: APIHandling = APIHandler()) {
        self.apiHandler = apiHandler
    }
    
    func fetchJobs(queryParams: String, completion: (() -> Void)?) {
        isLoading.toggle()
        apiHandler.fetchAccessToken { result in
            switch result {
                case .success(let accessToken):
                    self.apiHandler.fetchJobs(token: accessToken, queryParams: queryParams) { [self] result in
                        switch result {
                            case .success(let jobs):
                                DispatchQueue.main.async {
                                    self.jobs = jobs.resultats
                                    self.isLoading = false
                                }
                                guard let completion = completion else {
                                    return
                                }
                                completion()
                            case .failure(let err):
                                DispatchQueue.main.async {
                                    self.error.toggle()
                                    self.errorMessage = err.localizedDescription
                                    self.isLoading = false
                                }
                        }
                    }
                case .failure(let err):
                    DispatchQueue.main.async {
                        self.error.toggle()
                        self.errorMessage = err.localizedDescription
                        self.isLoading = false
                    }
            }
        }
    }
}
