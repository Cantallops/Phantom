//
//  UITableViewFullDelegateTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 13/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class UITableViewFullDelegateTest: XCTestCase {

    var tableView: UITableView!
    var fullD: UITableViewFullDelegate!

    override func setUp() {
        super.setUp()
        fullD = UITableViewFullDelegate()
        fullD.sections = getSections()
        tableView = UITableView()
        tableView.fullDelegate = fullD
    }

    func testUITableViewHasFullDelegateAsDelegateAndDataSource() {
        tableView.fullDelegate = nil
        XCTAssertNil(tableView.delegate)
        XCTAssertNil(tableView.dataSource)
        tableView.fullDelegate = fullD
        XCTAssertTrue(tableView.delegate === fullD)
        XCTAssertTrue(tableView.dataSource === fullD)
        XCTAssertTrue(tableView.fullDelegate === fullD)
    }

    func testEmptyView() {
        tableView.backgroundView = nil
        let emptyView = UIView()
        fullD.emptyView = emptyView
        XCTAssertEqual(fullD.emptyView, tableView.backgroundView)
    }

    func testDidSelectRow() {
        var selected = false
        fullD.sections = getSections(onSelect: {
            selected = true
        })
        fullD.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(selected)
    }

    func testWillSelectRow() {
        fullD.sections = getSections(canSelect: false)
        let idxPathToSelect = IndexPath(row: 0, section: 0)
        var idxPath = fullD.tableView(tableView, willSelectRowAt: idxPathToSelect)
        XCTAssertNil(idxPath)
        fullD.sections = getSections(canSelect: true)
        idxPath = fullD.tableView(tableView, willSelectRowAt: idxPathToSelect)
        XCTAssertEqual(idxPath, idxPathToSelect)
    }

    func testWillDisplayRow() {
        var selected = false
        fullD.sections = getSections(
            onSelect: {
                selected = true
            },
            initialySelected: true
        )
        let idxPath = IndexPath(row: 0, section: 0)
        let cell = TestTableViewCell()
        fullD.tableView(tableView, willDisplay: cell, forRowAt: idxPath)
        XCTAssertTrue(selected)
        XCTAssertTrue(cell.willDisplayCalled)
    }

    func testDidEndDisplayRow() {
        let cell = TestTableViewCell()
        let idxPath = IndexPath(row: 0, section: 0)
        fullD.tableView(tableView, didEndDisplaying: cell, forRowAt: idxPath)
        XCTAssertTrue(cell.didEndDisplayCalled)
    }

    func testHeightForRow() {
        fullD.sections = getSections(height: 10)
        let idxPath = IndexPath(row: 0, section: 0)
        let height = fullD.tableView(tableView, heightForRowAt: idxPath)
        XCTAssertEqual(height, 10)
    }
}

class TestTableViewCell: TableViewCell {
    var willDisplayCalled = false
    override func willDisplay() {
        willDisplayCalled = true
    }

    var didEndDisplayCalled = false
    override func didEndDisplay() {
        didEndDisplayCalled = true
    }
}

extension UITableViewFullDelegateTest {
    func getSections(
        onSelect: (() -> Void)? = nil,
        canSelect: Bool = true,
        initialySelected: Bool = false,
        height: CGFloat = UITableView.automaticDimension
    ) -> [UITableView.Section] {
        let cellConf = TableCellConf(identifier: "id", nib: nil)
        cellConf.onSelect = onSelect
        cellConf.deselect = true
        cellConf.canSelect = canSelect
        cellConf.initialySelected = initialySelected
        cellConf.height = height
        return [UITableView.Section(id: "id", cells: [cellConf])]
    }
}
