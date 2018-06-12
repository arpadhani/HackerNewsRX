//
//  Comment.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/11/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Comment: Item {
    let username: String
    let kids: [Int]
    let parent: Int
    let text: String

    override init?(json: JSON) {
        guard
            let username = json["by"].string,
            let kids = json["kids"].array,
            let parent = json["parent"].int,
            let text = json["text"].string
            else {
                return nil
        }

        self.username = username
        self.kids = kids.map { $0.intValue }
        self.parent = parent
        self.text = text

        super.init(json: json)
    }
}
