//
//  WebViewController.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/12/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import WebKit

final class WebViewController: BaseViewController {
    @IBOutlet weak var webView: WKWebView!

    var viewModel: WebViewViewModel! // dependency

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title

        view.backgroundColor = viewModel.theme.backgroundColor
        navigationController?.navigationBar.backgroundColor = viewModel.theme.themeColor

        let request = URLRequest(url: viewModel.url)
        webView.load(request)
    }
}
