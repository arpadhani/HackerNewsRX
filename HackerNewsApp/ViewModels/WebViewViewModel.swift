//
//  WebViewViewModel.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/12/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import RxSwift

class WebViewViewModel {
    // Observed at the Coordinator level.
    var theme: Observable<ThemeType>

    let url: URL
    let title: String

    init(story: Story, theme: Variable<(ThemeType)>) {
        self.url = story.url
        self.title = story.title

        self.theme = theme.asObservable()
    }
}
