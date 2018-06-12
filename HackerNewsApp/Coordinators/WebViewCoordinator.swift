//
//  WebViewCoordinator.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/12/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import UIKit

final class WebViewCoordinator: Coordinability {
    var childCoordinators: [Coordinability] = []

    private let nav: UINavigationController
    private let story: Story

    init(nav: UINavigationController?, story: Story) {
        self.nav = nav ?? UINavigationController()
        self.story = story
    }

    func start() {
        guard let webViewController = WebViewController.viewControllerFromStoryboard() as? WebViewController else {
            assertionFailure()
            return
        }
        webViewController.viewModel = WebViewViewModel(story: story)
        nav.pushViewController(webViewController, animated: true)
    }
}
