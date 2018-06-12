//
//  StoryBase.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/11/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

class StoryBase: Item {
    let username: String
    let descendants: Int
    let score: Int
    let title: String

    override init?(json: JSON) {
        guard
            let username =  json["by"].string,
            let descendants = json["descendants"].int,
            let score = json["score"].int,
            let title = json["title"].string
            else {
                return nil
        }

        self.username = username
        self.descendants = descendants
        self.score = score
        self.title = title

        super.init(json: json)
    }
}
