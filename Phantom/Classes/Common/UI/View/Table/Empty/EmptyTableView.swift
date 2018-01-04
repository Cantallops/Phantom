//
//  EmptyTableView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class EmptyTableView: UIView {
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var titleLabel: Label!
    var title: String!

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        customInit()
    }

    private func customInit() {
        setUpXib()
        titleLabel.text = title
    }

    private func setUpXib() {
        view = loadViewFromNib(name: "EmptyTableView")
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
