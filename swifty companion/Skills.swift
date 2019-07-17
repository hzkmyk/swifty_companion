//
//  Skill.swift
//  swifty companion
//
//  Created by Hazuki Miyake on 7/11/19.
//  Copyright © 2019 Hazuki Miyake. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Skills {
    let id: Int
    let name: String
    let level: Double
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        level = json["level"].doubleValue
    }
}
