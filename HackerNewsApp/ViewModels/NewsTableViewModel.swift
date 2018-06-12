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
    let items = Variable([Item]())
    
    init(items: [Item] = []) {
        self.items.value = items
    }

    func update(with newItems: [Item]) {
        items.value = newItems
    }
}
