//
//  EmptyTableSectionFooter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class EmptyTableSectionFooterConf: UITableViewSectionFooterConf {

    init(height: CGFloat = 20) {
        super.init(
            identifier: "EmptyTableSectionFooter",
            nib: UINib(nibName: "EmptyTableSectionFooterView", bundle: nil)
        )
        self.height = height
    }
}

class EmptyTableSectionFooterView: UITableViewSectionFooterView {

}
