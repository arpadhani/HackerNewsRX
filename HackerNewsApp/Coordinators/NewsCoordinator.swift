//
//  NewsCoordinator.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/7/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

final class NewsCoordinator: Coordinability {
    private var window: UIWindow?
    private var nav: UINavigationController?
    var childCoordinators: [Coordinability] = []

    // Coordinator Global
    let bag = DisposeBag()
    var newsViewController: TableViewController?
    private let theme: Variable<ThemeType>

    // News
    private var viewModel: NewsTableViewModel!

    init(window: UIWindow?, theme: Variable<ThemeType>) {
        self.window = window
        self.theme = theme
    }

    func start() {
        guard let newsVC = TableViewController.viewControllerFromStoryboard() as? TableViewController else {
            assertionFailure()
            return
        }

        self.newsViewController = newsVC
        newsVC.delegate = self

        let navigation = UINavigationController(rootViewController: newsVC)
        self.nav = navigation

        let newViewModel = NewsTableViewModel(theme: theme)
        self.viewModel = newViewModel
        newsVC.viewModel = self.viewModel

        window?.rootViewController = self.nav
        window?.makeKeyAndVisible()

        theme.asObservable()
            .subscribe { [weak self] type in
                self?.newsViewController?.navigationController?.navigationBar.backgroundColor = type.element?.themeColor
                self?.newsViewController?.themeButton.title = type.element?.oppositeTitle
            }
            .disposed(by: bag)
    }
}

extension NewsCoordinator: TableViewControllerDelegate {
    func userSelected(item: Item) {
        if let story = item as? Story {
            let webViewCoordinator = WebViewCoordinator(nav: nav, story: story, theme: theme)
            childCoordinators.append(webViewCoordinator)

            webViewCoordinator.start()
        }
    }

    func userSelectedThemeSwap() {
        theme.value = theme.value == .light ? .dark : .light
    }
}
