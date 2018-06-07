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
    private var baseVC: BaseViewController?
    private var newsViewController: TableViewController!
    private var nav: UINavigationController!

    init(baseVC: BaseViewController) {
        self.baseVC = baseVC
    }

    func start() {
        guard let newsVC = TableViewController.viewControllerFromStoryboard() as? TableViewController else {
            assertionFailure()
            return
        }

        self.nav = UINavigationController(rootViewController: newsVC)
        self.newsViewController = newsVC

        baseVC?.present(nav, animated: true, completion: nil)
    }
}
