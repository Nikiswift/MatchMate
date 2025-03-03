//
//  Repository.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//

import Foundation

protocol RepositoryProperties {
    associatedtype ModelType: Codable
    func getResponseData(url: String, model: ModelType.Type, isLocalFile: Bool) async throws -> ModelType
    func saveResponseData(model: ModelType)
    func saveResponseDataForKey(model: ModelType, updateId: String, newSelectionType: Int)
    func getSavedResponseData(model: ModelType.Type) throws -> ModelType
    func deleteData() -> CoreDataError
}

//MARK: Repository
class Repository<T: Codable>: RepositoryProperties {
    typealias ModelType = T
    
    private var networkManager: ApiServices

    init(networkManager: ApiServices) {
        self.networkManager = networkManager
    }
    
    func getResponseData(url: String, model: T.Type, isLocalFile: Bool) async throws -> T {
        do {
            return try await networkManager.fetchPosts(url: url, model: model, isLocalFile: isLocalFile)
        } catch {
            print("Failed to fetch response data:", error)
            throw error
        }
    }
    
    func saveResponseData(model: T) {
        do {
            let jsonData = try JSONEncoder().encode(model)
            CoreDataServices.save(data: jsonData, forKey: "HomeDataContent")
            print("Data saved successfully: \(jsonData)")
        } catch {
            print("Failed to encode content: \(error)")
        }
    }
    
    func saveResponseDataForKey(model: T, updateId: String, newSelectionType: Int) {
        do {
            var updatedModel = model
            
            if var baseModel = updatedModel as? Base {
                if let results = baseModel.results {
                    var updatedResults = results
                    
                    for index in updatedResults.indices {
                        if updatedResults[index].id?.value == updateId {
                            updatedResults[index].selectionType = newSelectionType
                        }
                    }
                    
                    baseModel.results = updatedResults
                    if let baseModelData = baseModel as? T {
                        updatedModel = baseModelData
                    }
                }
            }

            let jsonData = try JSONEncoder().encode(updatedModel)
            CoreDataServices.save(data: jsonData, forKey: "HomeDataContent")
            print("Data saved successfully: \(jsonData)")
        } catch {
            print("Failed to encode content: \(error)")
        }
    }



    
    func getSavedResponseData(model: T.Type) throws -> T {
        do {
            guard let cachedData = CoreDataServices.getData(forKey: "HomeDataContent") else {
                throw NetworkError.unknownError
            }
            let decoder = JSONDecoder()
            let savedContent = try decoder.decode(model, from: cachedData)
            return savedContent
        } catch {
            print("Failed to decode cached data: \(error)")
            throw error
        }
    }
    
    func deleteData() -> CoreDataError {
        do {
            CoreDataServices.deleteAll()
            return CoreDataError.deletedSuccesfully
        }
    }
}

