//
//  MateViewModel.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//

import Foundation
import Combine

 // MARK: MateViewModel
class MateViewModel: ObservableObject {
    var mainResponseData: Base?
    @Published var responseData: [Results] = []
    private var repository: Repository<Base>
    var url = MateSharedManager.shared.CONTENTSERVERADDRESS
    private var cancellables = Set<AnyCancellable>()
    var dashboardLoaded: Bool = false
    var paginingDefault = 10
    init(repository: Repository<Base>) {
        self.repository = repository
        self.handleNetworkStatus(page: paginingDefault)
    }
    
    func getMatesData(page: Int, loadLoacal: Bool = true) async {
        do {
            url = url + "\(page)"
            let matesData = try await self.repository.getResponseData(url: url, model: Base.self, isLocalFile: loadLoacal)
            DispatchQueue.main.async {
                self.mainResponseData = matesData
                if let resultData = matesData.results, !resultData.isEmpty {
                    self.responseData = self.mergeCoreDataWithNewData(newResults: resultData)
                    self.mainResponseData?.results = self.responseData
                    self.repository.saveResponseData(model: matesData)
                    self.dashboardLoaded = true
                }
            }
        } catch let error {
            self.dashboardLoaded = false
            await self.getMatesData(page: page, loadLoacal: true)
            print("Error Fetching Mates Data : \(error)")
        }
    }
    
    func updateSelectionValue(with id: String?, selection: Int) {
        if let base = mainResponseData, let updatedId = id {
            if let index = base.results?.firstIndex(where: {$0.id?.value == updatedId}) {
                self.mainResponseData?.results?[index].selectionType = selection
                self.responseData = self.mainResponseData?.results ?? []
            }
            if let updatedBase = self.mainResponseData {
                self.repository.saveResponseDataForKey(model: updatedBase, updateId: updatedId, newSelectionType: selection)
            }
        }
    }
    
    func mergeCoreDataWithNewData(newResults: [Results]) -> [Results] {
        do {
            let storedBaseModel = try self.repository.getSavedResponseData(model: Base.self)
            
            var storedResultsDict = [String: Int]()
            storedBaseModel.results?.forEach { storedResult in
                if let id = storedResult.id?.value {
                    storedResultsDict[id] = storedResult.selectionType
                }
            }
            
            let updatedResults = newResults.map { result -> Results in
                var modifiedResult = result
                if let id = result.id?.value {
                    if let selectionType = storedResultsDict[id] {
                        modifiedResult.selectionType = selectionType
                    }
                }
                return modifiedResult
            }
            
            return updatedResults
        } catch {
            print("Failed to fetch Core Data: \(error)")
            return newResults // Return unmodified in case of failure
        }
    }
    
    
    
    func handleNetworkStatus(page: Int) {
        NetworkConnectionHelper.shared.networkStatusPublisher
            .sink { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .online:
                    if self.responseData.isEmpty && dashboardLoaded {
                        Task {
                            await self.getMatesData(page: page)
                        }
                    }
                case .offline:
                    if let mateData = self.mainResponseData {
                        self.repository.saveResponseData(model: mateData)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func saveContent() {
        if let base = self.mainResponseData {
            self.repository.saveResponseData(model: base)
            print("Data saved successfully")
        }
    }
    
}
