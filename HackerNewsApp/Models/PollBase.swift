//
//  PollBase.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/11/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

class PollBase: Item {
    let username: String
    let score: Int
    let text: String

    override init?(json: JSON) {
        guard
            let username = json["by"].string,
            let score = json["score"].int,
            let text = json["text"].string
            else {
                return nil
        }

        self.username = username
        self.score = score
        self.text = text

        super.init(json: json)
    }
}
