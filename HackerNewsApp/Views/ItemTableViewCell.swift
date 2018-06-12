//
//  ItemTableViewCell.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/12/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import UIKit

final class ItemTableViewCell: UITableViewCell, Registerable {
    static var identifier = "ItemTableViewCellIdentifier"

    @IBOutlet weak var titleLabel: UILabel!
}
