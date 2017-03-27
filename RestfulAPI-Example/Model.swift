//
//  Model.swift
//  RestfulAPI-Example
//
//  Created by Chun-Tang Wang on 28/03/2017.
//  Copyright © 2017 Chun-Tang Wang. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONParsable {
    init(json: JSON)
}

struct Member: JSONParsable {
    let id: Int
    let name: String
    
    init(json: JSON) {
        id = json["ID"].intValue
        name = json["name"].stringValue
    }
}

struct Members: JSONParsable {
    var members: [Member]
    
    init(json: JSON) {
        members = [Member]()
        
        for (_, subJson) in json {
            let member = Member(json: subJson)
            members.append(member)
        }
    }
}
