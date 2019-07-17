//
//  User.swift
//  swifty companion
//
//  Created by Hazuki Miyake on 7/11/19.
//  Copyright © 2019 Hazuki Miyake. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONSerializable {
    func toJSON() -> JSON
}

struct Users {
    let login: String
    let iD: Int
    let imageURL: String
    let phone: String?
    let email: String
    let level: Double
    let wallet: Int
    let correctionPoint: Int
    let projects: [Projects]?
    let skills: [Skills]?
    
    init() {
        login = ""
        iD = 0
        imageURL = ""
        phone = ""
        email = ""
        level = 0
        wallet = 0
        correctionPoint = 0
        projects = nil
        skills = nil
    }
    
    init(json: JSON) {
        login = json["login"].stringValue
        iD = json["id"].intValue
        imageURL = json["image_url"].stringValue
        phone = json["phone"].stringValue
        email = json["email"].stringValue
        level = json["cursus_users"][0]["level"].doubleValue
        wallet = json["wallet"].intValue
        correctionPoint = json["correction_point"].intValue
        projects = json["projects_users"].arrayValue.map {
            Projects(json: $0)
        }
        skills = json["cursus_users"][0]["skills"].arrayValue.map { Skills(json: $0) }
    }
}

