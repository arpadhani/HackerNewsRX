//
//  User.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/7/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

final class User {
    let id: String
    let karma: Int
    let submitted: [Int]

    init?(json: JSON) {
        guard
            let id = json["id"].string,
            let karma = json["karma"].int,
            let submitted = json["submitted"].array
        else {
            return nil
        }

        self.id = id
        self.karma = karma
        self.submitted = submitted.map { $0.intValue }
    }
}
