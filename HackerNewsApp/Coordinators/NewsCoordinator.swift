//
//  NewsCoordinator.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/7/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import UIKit

final class NewsCoordinator: Coordinability {
    var childCoordinators: [Coordinability] = []
    private var nav: UINavigationController?
    private var viewModel = NewsTableViewModel()
    private var newsService = HackerNewsService()
    private var window: UIWindow?

    // pagination
    private var storyIDs = [Int]()
    private var inFlight: Bool = false
    private let limit: Int = 20 // stories
    private var offset: Int = 0
    private var totalCount: Int {
        return storyIDs.count
    }
    private let theme: Variable<ThemeType>


    init(window: UIWindow?, theme: Variable<ThemeType>) {
        self.window = window
        self.theme = theme
    }

    func start() {
        guard let newsVC = TableViewController.viewControllerFromStoryboard() as? TableViewController else {
            assertionFailure()
            return
        }

        newsVC.delegate = self

        self.nav = UINavigationController(rootViewController: newsVC)
        newsVC.viewModel = viewModel
        let newViewModel = NewsTableViewModel(theme: theme)

        window?.rootViewController = self.nav
        window?.makeKeyAndVisible()

        newsService.fetchTopStoriesIDs { [weak self] ids in
            self?.storyIDs = ids ?? []

            self?.fetchNextStoriesIfNeeded { [weak self] newStories in
                guard let newStories = newStories else { return }
                self?.viewModel.update(with: newStories)
        theme.asObservable()
            .subscribe { [weak self] type in
                self?.newsViewController?.navigationController?.navigationBar.backgroundColor = type.element?.themeColor
                self?.newsViewController?.themeButton.title = type.element?.oppositeTitle
            }
        }
    }

    private func fetchNextStoriesIfNeeded(completion: @escaping ([Story]?) -> Void) {
        guard inFlight == false, offset < totalCount else {
            completion(nil)
            return
        }

        var newStories = [Story]()
        let g = DispatchGroup()

        inFlight = true

        nextBatchOfStoryIDs().forEach { [weak self] id in
            g.enter()
            self?.newsService.fetchStory(with: id) { story in
                if let story = story {
                    newStories.append(story)
                }
                g.leave()
            }
        }

        g.notify(queue: .global(), execute: { [weak self] in
            self?.inFlight = false
            completion(newStories)
        })
    }

    private func nextBatchOfStoryIDs() -> [Int] {
        let previousOffset = offset

        let batchCount = (totalCount - offset > limit) ? limit : totalCount - offset
        offset += batchCount

        let storyIDsSlice = storyIDs[previousOffset..<offset]
        return Array(storyIDsSlice)
            .disposed(by: bag)
    }
}

extension NewsCoordinator: TableViewControllerDelegate {
    func tableViewControllerPulledToRefresh() {
        newsService.fetchTopStoriesIDs { [weak self] ids in
            self?.storyIDs = ids ?? []

            self?.offset = 0

            self?.fetchNextStoriesIfNeeded { [weak self] newStories in
                guard let newStories = newStories else { return }
                self?.viewModel.refresh(with: newStories)
            }
        }
    }

    func userSelected(item: Item) {
        if let story = item as? Story {
            let webViewCoordinator = WebViewCoordinator(nav: nav, story: story, theme: theme)
            childCoordinators.append(webViewCoordinator)

            webViewCoordinator.start()
        }
    }

    func userScrolledApproachingBottom() {
        fetchNextStoriesIfNeeded { [weak self] newStories in
            guard let newStories = newStories else { return }
            self?.viewModel.update(with: newStories)
        }
    func userSelectedThemeSwap() {
        theme.value = theme.value == .light ? .dark : .light
    }
}
