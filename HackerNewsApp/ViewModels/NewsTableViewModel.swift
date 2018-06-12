//
//  NewsTableViewModel.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/7/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import RxSwift

struct NewsTableViewModel {
    let title = "Hacker News"
    let theme = Theme()
    let items = Variable([Item]())
    let itemCellIdentifier = ItemTableViewCell.identifier
    let cellsToRegister = [ItemTableViewCell.self]
    let rowHeight = UITableViewAutomaticDimension
    let estimatedRowHeight = CGFloat(200)
    let footerView = UIView()
    
    init(items: [Item] = []) {
        self.items.value = items
    }

    func update(with newItems: [Item]) {
        items.value = newItems
    }
}
