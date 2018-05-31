//
//  SimpleTableSectionFooterView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SimpleTableSectionFooterConf: UITableViewSectionFooterConf {
    var title: String

    init(title: String) {
        self.title = title
        super.init(
            identifier: "SimpleTableSectionFooter",
            nib: UINib(nibName: "SimpleTableSectionFooterView", bundle: nil)
        )
    }
}

class SimpleTableSectionFooterView: UITableViewSectionFooterView {

    @IBOutlet weak var titleLabel: Label!
    var title: String = "" {
        didSet {
            titleLabel?.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
    }

    override func configure(with configuration: UITableViewSectionFooterConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? SimpleTableSectionFooterConf else {
            return
        }
        title = conf.title
    }

}
