//
//  PollOpt.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/11/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

final class PollOpt: PollBase {
    let poll: Int

    override init?(json: JSON) {
        guard let poll = json["poll"].int else { return nil }
        self.poll = poll

        super.init(json: json)
    }
}
