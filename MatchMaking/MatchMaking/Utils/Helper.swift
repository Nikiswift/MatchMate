//
//  Helper.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//

import Foundation
import UIKit

// MARK: MateSharedManager
class MateSharedManager {
    static let shared = MateSharedManager()
    init() {}
    let projectName = "Match Mate"
    let projectLogo = "ShaadiLogo"
    let headerHeading = "Interact With Your \nHappiness!"
    let headerTrailImage = "person.circle.fill"
    let screenBounds = UIScreen.main.bounds
    var CONTENTSERVERADDRESS = "https://randomuser.me/api/?results="
    
    func generateName(from mateData: Results) -> String {
        let firstName = mateData.name?.first ?? ""
        let lastName = mateData.name?.last ?? ""

        if let title = mateData.name?.title{
            return "\(title). \(firstName) \(lastName)"
        } else {
            return "\(firstName) \(lastName)"
        }
    }
    
    func generateLocation(from mateData: Results) -> String {
        let city = mateData.location?.city ?? ""
        let state = mateData.location?.state ?? ""
        return "\(city),\(state)"
    }
    func generateAge(from mateData: Results) -> String {
        if let age = mateData.dob?.age {
            return "Age: \(age)"
        }
        return ""
    }
}
