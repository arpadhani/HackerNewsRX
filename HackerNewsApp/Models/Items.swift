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

// MARK: - Story
class StoryBase: Item {
    let username: String
    let descendants: Int
    let kids: [Int]
    let score: Int
    let title: String

    override init?(json: JSON) {
        guard
            let username =  json["by"].string,
            let descendants = json["descendants"].int,
            let kids = json["kids"].array,
            let score = json["score"].int,
            let title = json["title"].string
        else {
            return nil
        }

        self.username = username
        self.descendants = descendants
        self.kids = kids.map { $0.intValue }
        self.score = score
        self.title = title

        super.init(json: json)
    }
}

final class Story: StoryBase {
    let url: URL

    override init?(json: JSON) {
        guard let urlString = json["url"].string, let url = URL(string: urlString) else { return nil }
        self.url = url

        super.init(json: json)
    }
}

final class Ask: StoryBase {
    let text: String

    override init?(json: JSON) {
        guard let text = json["text"].string else { return nil }
        self.text = text

        super.init(json: json)
    }
}

// MARK: - Comment
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

// MARK: - Job
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

// MARK: - Poll
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

final class PollOpt: PollBase {
    let poll: Int

    override init?(json: JSON) {
        guard let poll = json["poll"].int else { return nil }
        self.poll = poll

        super.init(json: json)
    }
}
