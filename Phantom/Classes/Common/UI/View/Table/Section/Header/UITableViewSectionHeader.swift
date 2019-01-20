//
//  UITableViewSectionHeader.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class UITableViewSectionHeaderConf: NSObject {
    var identifier: String = ""
    var nib: UINib?

    var height: CGFloat = UITableView.automaticDimension
    var estimatedHeight: CGFloat = 44

    init(
        identifier: String,
        nib: UINib?
    ) {
        self.identifier = identifier
        self.nib = nib
        super.init()
    }

    func height(forWidth width: CGFloat) -> CGFloat {
        if height != UITableView.automaticDimension {
            return height
        }
        guard let nib = nib,
            let view = nib.instantiate(withOwner: nil, options: nil).first as? UITableViewSectionHeaderView else {
                return  height
        }
        view.configure(with: self)
        return view.systemLayoutSizeFitting(
            CGSize(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height
    }

}

class UITableViewSectionHeaderView: UITableViewHeaderFooterView {
    func configure(with configuration: UITableViewSectionHeaderConf) {

    }
}
