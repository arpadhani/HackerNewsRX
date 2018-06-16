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

    let items = Variable([Item]())
    let itemCellIdentifier = ItemTableViewCell.identifier
    let rowHeight = UITableViewAutomaticDimension
    let estimatedRowHeight = CGFloat(44)
    let footerView = UIView()

    init(theme: Variable<(ThemeType)>) {
        self.theme = theme.asObservable()

    }
    }

    func refresh(with newItems: [Item]) {
        items.value = newItems
    }

    func update(with newItems: [Item]) {
        items.value.append(contentsOf: newItems)
    }
}
