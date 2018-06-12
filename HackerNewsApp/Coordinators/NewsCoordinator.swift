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

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        guard let newsVC = TableViewController.viewControllerFromStoryboard() as? TableViewController else {
            assertionFailure()
            return
        }

        newsVC.delegate = self

        self.nav = UINavigationController(rootViewController: newsVC)
        newsVC.viewModel = viewModel

        window?.rootViewController = self.nav
        window?.makeKeyAndVisible()

        fetchTopStories { [weak self] stories in
            self?.viewModel.update(with: stories)
        }
    }

    func fetchTopStories(completion: @escaping ([Story]) -> Void) {
        newsService.fetchTopStoriesIDs { [weak self] ids in
            guard let storyIDs = ids else {
                completion([])
                return
            }

            var stories = [Story]()
            let g = DispatchGroup()

            storyIDs.forEach { [weak self] id in
                g.enter()
                self?.newsService.fetchStory(with: id) { story in
                    if let story = story {
                        stories.append(story)
                    }
                    g.leave()
                }
            }

            g.notify(queue: .global(), execute: {
                completion(stories)
            })
        }
    }
}

extension NewsCoordinator: TableViewControllerDelegate {
    func tableViewControllerPulledToRefresh() {
        fetchTopStories { [weak self] stories in
            self?.viewModel.update(with: stories)
        }
    }

    func userSelected(item: Item) {
        if let story = item as? Story {
            let webViewCoordinator = WebViewCoordinator(nav: nav, story: story)
            childCoordinators.append(webViewCoordinator)

            webViewCoordinator.start()
        }
    }
}
