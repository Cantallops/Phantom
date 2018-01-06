//
//  MetaDataView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 22/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class MetaDataView: ViewController {

    @IBOutlet private weak var tableView: UITableView!

    // swiftlint:disable:next weak_delegate
    var fullDelegate: UITableViewFullDelegate?

    var sections: [UITableView.Section] = [] {
        didSet {
            fullDelegate?.sections = sections
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.lighterGrey
        setUpTable()
    }

    override func setUpNavigation() {
        navigationItem.title = "Meta Data"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    private func setUpTable() {
        fullDelegate = UITableViewFullDelegate()
        tableView.fullDelegate = fullDelegate
        fullDelegate?.sections = sections
        tableView.tableFooterView = UIView()
    }

}
