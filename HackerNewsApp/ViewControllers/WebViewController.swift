//
//  WebViewController.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/12/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import WebKit

final class WebViewController: BaseViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    var viewModel: WebViewViewModel! // dependency

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        webView.allowsBackForwardNavigationGestures = true

        viewModel.theme
            .subscribe { [weak self] type in
                self?.view.backgroundColor = type.element?.backgroundColor
            }

        backButton.rx.tap
            .subscribe { [weak self] _ in
                self?.webView.goBack()
            }.disposed(by: bag)

        forwardButton.rx.tap
            .subscribe { [weak self] _ in
                self?.webView.goForward()
            }.disposed(by: bag)

        refreshButton.rx.tap
            .subscribe { [weak self] _ in
                self?.webView.reloadFromOrigin()
            }.disposed(by: bag)

        shareButton.rx.tap
            .subscribe { [weak self] _ in
                guard let url = self?.webView.url else { return }
                let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
                self?.present(vc, animated: true)
            }.disposed(by: bag)

        let request = URLRequest(url: viewModel.url)
        webView.load(request)
    }
}
