//
//  Theme.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/12/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import UIKit

enum ThemeType {
    case light
    case dark

    var oppositeTitle: String {
        switch self {
        case .light:
            return "Dark"
        case .dark:
            return "Light"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        case .dark:
            return .lightGray
        }
    }

    var themeColor: UIColor {
        switch self {
        case .light:
            return UIColor(red: 252.0/255.0, green: 102.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        case .dark:
            return .darkGray
        }
    }
}
