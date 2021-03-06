//
//  SimpleTableSectionHeaderView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SimpleTableSectionHeaderConf: UITableViewSectionHeaderConf {
    var title: String

    init(title: String) {
        self.title = title
        super.init(
            identifier: "SimpleTableSectionHeader",
            nib: UINib(nibName: "SimpleTableSectionHeaderView", bundle: nil)
        )
    }
}

class SimpleTableSectionHeaderView: UITableViewSectionHeaderView {

    @IBOutlet fileprivate weak var titleLabel: Label!
    var title: String = "" {
        didSet {
            titleLabel?.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
    }

    override func configure(with configuration: UITableViewSectionHeaderConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? SimpleTableSectionHeaderConf else {
            return
        }
        title = conf.title
    }

}
