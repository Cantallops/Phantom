//
//  EmptyTableSectionHeader.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class EmptyTableSectionHeaderConf: UITableViewSectionHeaderConf {

    init(height: CGFloat = 20) {
        super.init(
            identifier: "EmptyTableSectionHeader",
            nib: UINib(nibName: "EmptyTableSectionHeaderView", bundle: nil)
        )
        self.height = height
    }
}

class EmptyTableSectionHeaderView: UITableViewSectionHeaderView {

}
