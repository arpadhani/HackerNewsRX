//
//  Items.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/7/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Common Base
class Item {
    let id: Int
    let time: TimeInterval

    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let timeFloat = json["time"].float,
            let time = TimeInterval(exactly: timeFloat)
        else {
            return nil
        }

        self.id = id
        self.time = time
    }
}
