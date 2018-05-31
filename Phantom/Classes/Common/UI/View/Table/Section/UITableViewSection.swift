//
//  UITableViewSection.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

extension UITableView {
    struct Section: Equatable, Collection {
        typealias Index  = Int
        typealias Element = TableCellConf

        var id: String
        var header: UITableViewSectionHeaderConf?
        var cells: [TableCellConf]
        var footer: UITableViewSectionFooterConf?

        init(
            id: String,
            header: UITableViewSectionHeaderConf? = nil,
            cells: [TableCellConf],
            footer: UITableViewSectionFooterConf? = nil
        ) {
            self.id = id
            self.header = header
            self.cells = cells
            self.footer = footer
        }

        var startIndex: Int {
            return cells.startIndex
        }

        var endIndex: Int {
            return cells.endIndex
        }

        // swiftlint:disable:next identifier_name
        subscript(i: Int) -> TableCellConf {
            return cells[i]
        }

        // swiftlint:disable:next identifier_name
        public func index(after i: Int) -> Int {
            return cells.index(after: i)
        }

        static func == (lhs: UITableView.Section, rhs: UITableView.Section) -> Bool {
            return lhs.id == rhs.id
        }
    }
}
