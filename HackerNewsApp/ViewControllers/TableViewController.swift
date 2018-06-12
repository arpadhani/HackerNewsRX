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

protocol TableViewControllerDelegate: class {
    func tableViewControllerPulledToRefresh()
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
        view.backgroundColor = viewModel.theme.backgroundColor
        navigationController?.navigationBar.backgroundColor = viewModel.theme.themeColor

        tableView.backgroundColor = viewModel.theme.backgroundColor
        tableView.rowHeight = viewModel.rowHeight
        tableView.estimatedRowHeight = viewModel.estimatedRowHeight
        tableView.tableFooterView = viewModel.footerView
        tableView.refreshControl = refreshControl

        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            .subscribe(onNext: { value in
                print("Value")
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
    }
}

