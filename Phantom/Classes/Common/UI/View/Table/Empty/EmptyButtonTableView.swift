//
//  EmptyButtonTableView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class EmptyButtonTableView: UIView {

    @IBOutlet private var view: UIView!
    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private weak var button: Button!
    var title: String!
    var buttonTitle: String!
    var buttonAction: (() -> Void)!

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    init(title: String, buttonTitle: String, buttonAction: @escaping () -> Void) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        customInit()
    }

    private func customInit() {
        setUpXib()
        titleLabel.text = title
        button.setTitle(buttonTitle, for: .normal)
    }

    @IBAction private func tapButton() {
        buttonAction()
    }

    private func setUpXib() {
        view = loadViewFromNib(name: "EmptyButtonTableView")
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
