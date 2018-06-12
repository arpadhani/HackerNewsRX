//
//  Job.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/11/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Job: Item {
    let username: String
    let score: Int
    let title: String
    let text: String

    override init?(json: JSON) {
        guard
            let username = json["by"].string,
            let score = json["score"].int,
            let title = json["title"].string,
            let text = json["text"].string
            else {
                return nil
        }

        self.username = username
        self.score = score
        self.title = title
        self.text = text

        super.init(json: json)
    }
}
