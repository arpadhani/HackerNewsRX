//
//  Poll.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/11/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Poll: PollBase {
    let descendants: Int
    let kids: [Int]
    let parts: [Int]
    let title: String

    override init?(json: JSON) {
        guard
            let descendants = json["descendants"].int,
            let kids = json["kids"].array,
            let parts = json["parts"].array,
            let title = json["title"].string
            else {
                return nil
        }

        self.descendants = descendants
        self.kids = kids.map{ $0.intValue }
        self.parts = parts.map{ $0.intValue }
        self.title = title

        super.init(json: json)
    }
}
