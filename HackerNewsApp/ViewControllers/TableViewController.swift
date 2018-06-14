//
//  TableViewController.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/7/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

// TableViewControllerDelegate using non-standard delegate naming pattern otherwise we would need to unwarp `self` for only this purpose.
protocol TableViewControllerDelegate: class {
    func tableViewControllerPulledToRefresh()
    func userSelected(item: Item)
    func userScrolledApproachingBottom()
}

final class TableViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    weak var delegate: TableViewControllerDelegate?

    var viewModel: NewsTableViewModel! // dependency
    var datasource: Observable<([Item])> {
        return viewModel.items.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title

        view.backgroundColor = viewModel.theme.backgroundColor
        navigationController?.navigationBar.backgroundColor = viewModel.theme.themeColor

        tableView.backgroundColor = viewModel.theme.backgroundColor
        tableView.rowHeight = viewModel.rowHeight
        tableView.estimatedRowHeight = viewModel.estimatedRowHeight
        tableView.tableFooterView = viewModel.footerView
        tableView.refreshControl = refreshControl

        bind()
    }

    private func bind() {
        // TableView
        datasource
            .bind(to: tableView.rx.items(cellIdentifier: ItemTableViewCell.identifier, cellType: ItemTableViewCell.self)) { row, element, cell in
                DispatchQueue.main.async { [weak self] in
                    if let refresh = self?.refreshControl, refresh.isRefreshing {
                        self?.refreshControl.endRefreshing()
                    }

                    if let story = element as? Story {
                        cell.titleLabel?.text = story.title
                    }
                }
            }
            .disposed(by: bag)

        tableView.rx
            .modelSelected(Item.self)
            .subscribe(onNext: { [weak self] value in
                self?.delegate?.userSelected(item: value)
            })
            .disposed(by: bag)

        // Refresh Control
        refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in !self.refreshControl.isRefreshing }
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.tableViewControllerPulledToRefresh()
            })
            .disposed(by: bag)

        tableView.rx.didScroll
            .map { _ in self.tableView }
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                if ((strongSelf.tableView.contentOffset.y + strongSelf.tableView.frame.size.height) >= (strongSelf.tableView.contentSize.height - 100)) {
                    self?.delegate?.userScrolledApproachingBottom()
                }
            }
    }
}

