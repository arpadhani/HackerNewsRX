//
//  Coordinator.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/7/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinability {
    var childCoordinators: [Coordinability] { get set }
    func start()
}

class Coordinator: Coordinability {
    private var window: UIWindow?
    var childCoordinators: [Coordinability] = []

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        guard let baseVC = BaseViewController.viewControllerFromStoryboard() as? BaseViewController else {
            assertionFailure()
            return
        }

        window?.rootViewController = baseVC
        window?.makeKeyAndVisible()

        let newsCoordinator = NewsCoordinator(baseVC: baseVC)
        childCoordinators.append(newsCoordinator)
        newsCoordinator.start()
    }
}
