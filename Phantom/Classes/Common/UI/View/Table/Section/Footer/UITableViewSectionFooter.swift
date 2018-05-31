//
//  UITableViewSectionFooter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class UITableViewSectionFooterConf: NSObject {
    var identifier: String = ""
    var nib: UINib?

    var height: CGFloat = UITableViewAutomaticDimension
    var estimatedHeight: CGFloat = 44

    init(
        identifier: String,
        nib: UINib?
    ) {
        self.identifier = identifier
        self.nib = nib
        super.init()
    }

    func height(forWidth width: CGFloat) -> CGFloat {
        return height
    }

}

class UITableViewSectionFooterView: UITableViewHeaderFooterView {
    func configure(with configuration: UITableViewSectionFooterConf) {

    }
}
