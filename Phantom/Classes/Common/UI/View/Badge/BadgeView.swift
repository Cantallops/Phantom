//
//  BadgeView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class BadgeView: UIView {
    private var view: UIView!

    @IBOutlet private weak var badgeLabel: Label!

    var text: String? {
        didSet {
            badgeLabel?.text = text
        }
    }
    var textColor: UIColor = Color.midGrey {
        didSet {
            badgeLabel.textColor = textColor
        }
    }
    var color: UIColor = .clear {
        didSet {
            view.backgroundColor = color
        }
    }

    override var backgroundColor: UIColor? { // Avoid change
        didSet {
            if backgroundColor != .clear {
                backgroundColor = .clear
            }
        }
    }

    var showBorder: Bool = true {
        didSet {
            redrawBorder()
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

    private func customInit() {
        setUpXib()
        layer.cornerRadius = 3
        clipsToBounds = true
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        badgeLabel.text = text
        badgeLabel.textColor = textColor
        view.backgroundColor = color
        redrawBorder()
    }

    private func redrawBorder() {
        view.layer.borderWidth = showBorder ? 1 : 0
        view.layer.borderColor = Color.lightGrey.cgColor
    }

    private func setUpXib() {
        view = loadViewFromNib(name: "BadgeView")
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
