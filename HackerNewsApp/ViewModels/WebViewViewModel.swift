//
//  WebViewViewModel.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/12/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation

struct WebViewViewModel {
    let url: URL
    let theme = Theme()
    let title: String

    init(story: Story) {
        self.url = story.url
        self.title = story.title
    }
}
