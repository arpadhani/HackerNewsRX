//
//  HackerNewsService.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/8/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import SwiftyJSON

enum HackerNewsAPIVersion: String {
    case v0
}

enum HackerNewsURI {
    case topStories
    case newstories
    case beststories
    case story(item: Int) // https://hacker-news.firebaseio.com/v0/item/8863

    private func components() -> [String] {
        switch self {
        case .topStories: return ["topstories"]
        case .newstories: return ["newstories"]
        case .beststories: return ["beststories"]
        case .story(let item): return ["item", String(item)]
        }
    }

    func uri(apiVersion: HackerNewsAPIVersion = .v0) -> URL {
        let base = URL(string: "https://hacker-news.firebaseio.com/\(apiVersion.rawValue)/")!
        switch self {
        case .topStories, .newstories, .beststories, .story:
            return components().reduce(base, { result, component in
                return result.appendingPathComponent(component)
            }).appendingPathComponent(".json")
        }
    }
}

class HackerNewsService: Service {
    func fetchStory(with storyID: Int, completion: @escaping (Item?) -> Void) {
        fetch(.story(item: storyID)) { json in
            guard
                let json = json,
                let type = json["type"].string,
                let itemType = ItemType(rawValue: type)
            else {
                completion(nil)
                return
            }

            switch itemType {
            case .comment, .pollOpt:
                assertionFailure() // these shouldn't exist at the story level/hierarchy
            case .poll:
                let p = Poll(json: json)
                completion(nil)
            case .job:
                completion(Job(json: json))
            case .story:
                if json["url"].string == "" {
                    completion(Ask(json: json))
                } else {
                    completion(Story(json: json))
                }
            }
        }
    }

    func fetchTopStoriesIDs(completion: @escaping ([Int]?) -> Void) {
        fetch(.topStories) { json in
            completion(json?.arrayValue.map { $0.intValue })
        }
    }
}

private extension HackerNewsService {
    func fetch(_ type: HackerNewsURI, completion: @escaping (JSON?) -> Void) {
        request(url: type.uri(), completion: completion)
    }
}
