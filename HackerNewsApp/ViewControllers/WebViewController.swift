//
//  WebViewController.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/12/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import RxSwift
import WebKit

final class WebViewController: BaseViewController {
    @IBOutlet weak var webView: WKWebView!

    var viewModel: WebViewViewModel! // dependency

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title

        viewModel.theme
            .subscribe { [weak self] type in
                self?.view.backgroundColor = type.element?.backgroundColor
            }

        let request = URLRequest(url: viewModel.url)
        webView.load(request)
    }
}
