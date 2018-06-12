//
//  Story.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/11/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Story: StoryBase {
    let url: URL

    override init?(json: JSON) {
        guard let urlString = json["url"].string, let url = URL(string: urlString) else { return nil }
        self.url = url

        super.init(json: json)
    }
}
