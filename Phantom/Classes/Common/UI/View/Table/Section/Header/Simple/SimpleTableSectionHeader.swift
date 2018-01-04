//
//  SimpleTableSectionHeader.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

struct SimpleTableSectionHeader: UITableViewSectionHeader {
    var customView: UIView

    init(title: String) {
        let header = SimpleTableSectionHeaderView()
        header.title = title
        customView = header
    }
}

class SimpleTableSectionHeaderView: UIView {

    @IBOutlet fileprivate weak var titleLabel: Label!
    private var view: UIView!
    var title: String = "" {
        didSet {
            titleLabel?.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = title
    }

    private func customInit() {
        setUpXib()
    }

    private func setUpXib() {
        view = loadViewFromNib(name: "SimpleTableSectionHeaderView")
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
