//
//  UITableViewSection.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

extension UITableView {
    struct Section {
        var header: UITableViewSectionHeader?
        var cells: [TableCellConf]
        var footer: UITableViewSectionFooter?

        init(
            header: UITableViewSectionHeader? = nil,
            cells: [TableCellConf],
            footer: UITableViewSectionFooter? = nil
        ) {
            self.header = header
            self.cells = cells
            self.footer = footer
        }
    }
}
