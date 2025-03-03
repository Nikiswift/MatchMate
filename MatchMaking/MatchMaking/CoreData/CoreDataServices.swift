//
//  CoreDataServices.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//
import Foundation
import CoreData
import UIKit

enum CoreDataError: Error {
    case deletedSuccesfully
    case failedDeletingData
}

@objc(MateResponseDataModel)
public class MateResponseDataModel: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MateResponseDataModel> {
        return NSFetchRequest<MateResponseDataModel>(entityName: "MateResponseDataModel")
    }

    @NSManaged public var id: String?
    @NSManaged public var response: Data?
}
//MARK: CoreData Services
final class CoreDataServices {
    private static let context = PersistenceController.shared.container.viewContext
    
    static func save(data: Data, forKey key: String) {
        let fetchRequest: NSFetchRequest<MateResponseDataModel> = MateResponseDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", key)
        
        do {
            let results = try context.fetch(fetchRequest)
            let responseModel = results.last ?? MateResponseDataModel(context: context)
            responseModel.id = key
            responseModel.response = data
            
            try context.save()
        } catch {
            print("Failed to save data for key '\(key)': \(error.localizedDescription)")
        }
    }
    
    static func getData(forKey key: String) -> Data? {
        let fetchRequest: NSFetchRequest<MateResponseDataModel> = MateResponseDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", key)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.last?.response
        } catch {
            print("Failed to fetch data for key '\(key)': \(error.localizedDescription)")
            return nil
        }
    }
    
    static func deleteData(forKey key: String) {
        let fetchRequest: NSFetchRequest<MateResponseDataModel> = MateResponseDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", key)
        
        do {
            if let responseModel = try context.fetch(fetchRequest).last {
                context.delete(responseModel)
                try context.save()
            }
        } catch {
            print("Failed to delete data for key '\(key)': \(error.localizedDescription)")
        }
    }
    
    static func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MateResponseDataModel.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete all data: \(error.localizedDescription)")
        }
    }
    
}
