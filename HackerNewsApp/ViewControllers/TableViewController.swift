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

final class TableViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    var viewModel: NewsTableViewModel! // dependency
    var datasource: Observable<([Item])> {
        return viewModel.items.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // register cells

        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func bind() {
        datasource
            .bind(to: tableView.rx.items(cellIdentifier: "TEST", cellType: UITableViewCell.self)) { row, element, cell in
                DispatchQueue.main.async {
                    if let story = element as? Story {
                        cell.textLabel?.text = story.title
                    }
                }
            }
            .disposed(by: bag)
    }
}

