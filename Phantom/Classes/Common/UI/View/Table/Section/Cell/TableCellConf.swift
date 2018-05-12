//
//  TableCellConf.swift
//  Phantom
//
//  Created by Alberto Cantallops on 28/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TableCellConf: NSObject {
    var identifier: String = ""
    var nib: UINib?

    var accessoryView: UIView?
    var accessoryType: UITableViewCellAccessoryType = .none
    var selectionColor: UIColor = Color.lightBlue

    var onSelect: (() -> Void)?
    var deselect: Bool = false
    var showSelection: Bool = true
    var canSelect: Bool = true {
        didSet {
            if !canSelect {
                showSelection = false
            }
        }
    }

    var height: CGFloat = UITableViewAutomaticDimension
    var estimatedHeight: CGFloat = 44

    var initialySelected: Bool = false
    var behaveAsRadioButton: Bool = false

    init(
        identifier: String,
        nib: UINib?
    ) {
        self.identifier = identifier
        self.nib = nib
        super.init()
    }

}

class TableViewCell: UITableViewCell {
    var blockSelectChangeColor: [UIView] = []
    var showTickOnSelection: Bool = false
    var showSelection: Bool = true
    private let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.lightBlue
        view.layer.cornerRadius = 4
        return view
    }()

    var refreshHeight: (() -> Void)?
    var tapItself: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedView.frame = getFrameForSelection()
        selectedBackgroundView = selectedView
    }

    func configure(with configuration: TableCellConf) {
        contentView.autoresizingMask = .flexibleHeight
        accessoryView = configuration.accessoryView
        accessoryType = configuration.accessoryType
        selectionStyle = configuration.showSelection ? selectionStyle : .none
        showTickOnSelection = configuration.behaveAsRadioButton
        showSelection = configuration.showSelection
        selectedView.backgroundColor = configuration.selectionColor
    }

    func selectItself() {
        tapItself?()
    }

    func willDisplay() {
    }

    func didEndDisplay() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if showTickOnSelection {
            accessoryType = selected ? .checkmark : .none
        }
        performBlockColor {
            super.setSelected(selected, animated: animated)
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        performBlockColor {
            super.setHighlighted(highlighted, animated: animated)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        selectedView.frame = getFrameForSelection()
    }

    private func getFrameForSelection() -> CGRect {
        var selectedFrame = bounds
        let correction: CGFloat = 8
        selectedFrame.size.width -= layoutMargins.left + layoutMargins.right - correction*2
        selectedFrame.origin.x += layoutMargins.left - correction

        return selectedFrame
    }
}

private extension TableViewCell {
    func performBlockColor(_ action: () -> Void) {
        let colors = blockSelectChangeColor.reduce([:]) { (partialResult, view) -> [UIView: UIColor?] in
            var mutableResult = partialResult
            mutableResult[view] = view.backgroundColor
            return mutableResult
        }
        action()
        colors.forEach { (view: UIView, color: UIColor?) in
            view.backgroundColor = color
        }
    }
}
