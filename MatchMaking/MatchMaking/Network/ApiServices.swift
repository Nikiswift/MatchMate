//
//  ApiServices.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 28/02/25.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case unknownError
    case fileNotFound
}

protocol APIServicesProtocol {
    func fetchPosts<T: Decodable>(url: String,model: T.Type, isLocalFile: Bool) async throws -> T
}

//MARK: Api Services
final class ApiServices: APIServicesProtocol {
    func fetchPosts<T: Decodable>(url: String, model: T.Type, isLocalFile: Bool) async throws -> T {
        if isLocalFile {
            return try fetchLocalJSON(filename: "sample", model: model)
        } else {
            return try await fetchRemoteJSON(url: url, model: model)
        }
    }
    
    //MARK:  Fetch JSON from a remote API

    private func fetchRemoteJSON<T: Decodable>(url: String, model: T.Type) async throws -> T {
        guard let validURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(validURL, method: .get, headers: ["Content-Type": "application/json"])
                .validate(statusCode: 200...299)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        continuation.resume(returning: decodedData)
                        
                    case .failure(let error):
                        if let afError = error.asAFError {
                            if afError.isResponseSerializationError {
                                continuation.resume(throwing: NetworkError.decodingError)
                            } else if afError.isSessionTaskError {
                                continuation.resume(throwing: NetworkError.unknownError)
                            } else {
                                continuation.resume(throwing: NetworkError.invalidResponse)
                            }
                        } else {
                            continuation.resume(throwing: NetworkError.unknownError)
                        }
                    }
                }
        }
    }
    
    
    //MARK: Fetch Local JSON
    private func fetchLocalJSON<T: Decodable>(filename: String, model: T.Type) throws -> T {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            throw NetworkError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode(T.self, from: data)
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknownError
        }
    }
    
}

