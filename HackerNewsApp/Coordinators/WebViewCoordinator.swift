//
//  WebViewCoordinator.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/12/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import RxSwift
import UIKit

final class WebViewCoordinator: Coordinability {
    var childCoordinators: [Coordinability] = []
    private let nav: UINavigationController

    // Coordinator Global
    // let bag = DisposeBag() unused at this time
    private let theme: Variable<ThemeType>

    private let story: Story

    init(nav: UINavigationController?, story: Story, theme: Variable<ThemeType>) {
        self.nav = nav ?? UINavigationController()
        self.story = story
        self.theme = theme
    }

    func start() {
        guard let webViewController = WebViewController.viewControllerFromStoryboard() as? WebViewController else {
            assertionFailure()
            return
        }
        webViewController.viewModel = WebViewViewModel(story: story, theme: theme)
        nav.pushViewController(webViewController, animated: true)
    }
}
