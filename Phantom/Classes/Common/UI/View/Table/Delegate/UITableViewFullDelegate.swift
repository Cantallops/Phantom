//
//  UITableViewFullDelegate.swift
//  Phantom
//
//  Created by Alberto Cantallops on 27/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import Differ

extension UITableView {
    weak var fullDelegate: UITableViewFullDelegate? {
        set {
            newValue?.table = self
            delegate = newValue
            dataSource = newValue
        }
        get {
            return delegate as? UITableViewFullDelegate
        }
    }
}

class UITableViewFullDelegate: NSObject {
    var table: UITableView!
    var animatedChanges: Bool = false
    var emptyView: UIView? {
        didSet {
            table?.backgroundView = emptyView
        }
    }
    var sections: [UITableView.Section] = [] {
        didSet {
            if !animatedChanges {
                table?.reloadData()
            } else {
                table?.animateRowAndSectionChanges(
                    oldData: oldValue,
                    newData: sections,
                    rowDeletionAnimation: .middle,
                    rowInsertionAnimation: .middle,
                    sectionDeletionAnimation: .middle,
                    sectionInsertionAnimation: .middle
                )
            }
        }
    }
}

extension UITableViewFullDelegate: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let cellConfiguration = section.cells[indexPath.row]
        cellConfiguration.onSelect?()

        if cellConfiguration.deselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let section = sections[indexPath.section]
        let cellConfiguration = section.cells[indexPath.row]
        if !cellConfiguration.canSelect {
            return nil
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let cellConfiguration = section.cells[indexPath.row]
        if cellConfiguration.initialySelected {
            cellConfiguration.initialySelected = false
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cellConfiguration.onSelect?()
        }
        if let cell = cell as? TableViewCell {
            cell.willDisplay()
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TableViewCell {
            cell.didEndDisplay()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let cellConfiguration = section.cells[indexPath.row]
        return cellConfiguration.height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let tableSection = sections[section]
        guard let header = tableSection.header else {
            return 0.01
        }
        return header.height(forWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let tableSection = sections[section]
        guard let footer = tableSection.footer else {
            return 0.01
        }
        return footer.height(forWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let cellConfiguration = section.cells[indexPath.row]
        return cellConfiguration.estimatedHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        return section.header?.customView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = sections[section]
        return section.footer?.customView
    }
}

extension UITableViewFullDelegate: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = (sections.count > 0)
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cellConfiguration = section.cells[indexPath.row]
        let cell = getCell(in: tableView, forRowAt: indexPath, withConf: cellConfiguration)
        cell.configure(with: cellConfiguration)
        cell.tapItself = {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cellConfiguration.onSelect?()
        }
        cell.refreshHeight = {
            if #available(iOS 11.0, *) {
                tableView.performBatchUpdates(nil)
            } else {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        return cell
    }

    private func getCell(
        in tableView: UITableView,
        forRowAt indexPath: IndexPath,
        withConf conf: TableCellConf
    ) -> TableViewCell {
        let identifier = conf.identifier
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TableViewCell {
            return cell
        }
        let nib = conf.nib
        tableView.register(nib, forCellReuseIdentifier: identifier)
        let reusedCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let cell = reusedCell as? TableViewCell else {
            fatalError() // Show fancy error
        }

        return cell
    }
}
