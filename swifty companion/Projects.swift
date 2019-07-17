//
//  Project.swift
//  swifty companion
//
//  Created by Hazuki Miyake on 7/11/19.
//  Copyright © 2019 Hazuki Miyake. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Projects {
    let projectName: String
    let iD: Int
    let projectID: Int
    let parentID: Int
    let finished: Bool
    let marked: Bool
    let markedAt: String?
    let finalMark: Int?
    let validated: Bool
    
    init(json: JSON) {
        projectName = json["project"]["name"].stringValue
        iD = json["id"].intValue
        projectID = json["project"]["id"].intValue
        parentID = json["project"]["parent_id"].intValue
        finished = json["status"].stringValue == "finished" ? true : false
        marked = json["marked"].boolValue
        markedAt = json["marked_at"].stringValue
        finalMark = json["final_mark"].intValue
        validated = json["validated?"].boolValue
    }
}
