//
//  NewsTableViewModel.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/7/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import RxSwift

class NewsTableViewModel {
    // Observed at the Coordinator level.
    var theme: Observable<ThemeType>

    // Updated and Managed from ViewModel. Coordinator has no need to know about this.
    let items = Variable([Item]())

    private var newsService = HackerNewsService()

    // News Pagination
    private let limit: Int = 20 // number of stories at one time
    private var storyIDs = [Int]()
    private var inFlight: Bool = false
    private var offset: Int = 0
    private var totalCount: Int {
        return storyIDs.count
    }

    let title = "News"
    let itemCellIdentifier = ItemTableViewCell.identifier
    let rowHeight = UITableViewAutomaticDimension
    let estimatedRowHeight = CGFloat(80)
    let footerView = UIView()

    init(theme: Variable<(ThemeType)>) {
        self.theme = theme.asObservable()

        newsService.fetchTopStoriesIDs { [weak self] ids in
            self?.storyIDs = ids ?? []

            self?.fetchNextStoriesIfNeeded { [weak self] newStories in
                guard let newStories = newStories else { return }
                self?.update(with: newStories)
            }
        }
    }

    private func fetchNextStoriesIfNeeded(completion: @escaping ([Item]?) -> Void) {
        guard inFlight == false, offset < totalCount else {
            completion(nil)
            return
        }

        var newItems = [Item]()
        let g = DispatchGroup()

        inFlight = true

        nextBatchOfStoryIDs().forEach { [weak self] id in
            g.enter()
            self?.newsService.fetchStory(with: id) { item in
                if let newItem = item {
                    newItems.append(newItem)
                }
                g.leave()
            }
        }

        g.notify(queue: .global(), execute: { [weak self] in
            self?.inFlight = false
            completion(newItems)
        })
    }

    private func nextBatchOfStoryIDs() -> [Int] {
        let previousOffset = offset

        let batchCount = (totalCount - offset > limit) ? limit : totalCount - offset
        offset += batchCount

        let storyIDsSlice = storyIDs[previousOffset..<offset]
        return Array(storyIDsSlice)
    }

    func refresh(with newItems: [Item]) {
        items.value = newItems
    }

    func update(with newItems: [Item]) {
        items.value.append(contentsOf: newItems)
    }
}

// View Controller initiated datasource manipulated methods
extension NewsTableViewModel {
    func tableViewControllerPulledToRefresh() {
        newsService.fetchTopStoriesIDs { [weak self] ids in
            self?.storyIDs = ids ?? []

            self?.offset = 0

            self?.fetchNextStoriesIfNeeded { [weak self] newStories in
                guard let newStories = newStories else { return }
                self?.refresh(with: newStories)
            }
        }
    }

    func userScrolledApproachingBottom() {
        fetchNextStoriesIfNeeded { [weak self] newStories in
            guard let newStories = newStories else { return }
            self?.update(with: newStories)
        }
    }
}
