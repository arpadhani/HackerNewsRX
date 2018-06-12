//
//  Ask.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/11/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Ask: StoryBase {
    let text: String

    override init?(json: JSON) {
        guard let text = json["text"].string else { return nil }
        self.text = text

        super.init(json: json)
    }
}
