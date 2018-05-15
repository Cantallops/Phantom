//
//  SimpleTableSectionFooter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

struct SimpleTableSectionFooter: UITableViewSectionFooter {
    var customView: UIView

    init(title: String) {
        let footer = SimpleTableSectionFooterView()
        footer.title = title
        customView = footer
    }
}

class SimpleTableSectionFooterView: UIView {

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
        backgroundColor = Color.white
    }

    private func setUpXib() {
        view = loadViewFromNib(name: "SimpleTableSectionFooterView")
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
