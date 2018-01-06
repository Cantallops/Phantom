//
//  AttributedTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AttributedTableViewCell: TableViewCell {

    @IBOutlet weak var label: UITextView!

    class Conf: TableCellConf {
        var text: NSAttributedString

        init(
            text: NSAttributedString
        ) {
            self.text = text
            super.init(
                identifier: "AttributedCell",
                nib: UINib(nibName: "AttributedTableViewCell", bundle: nil)
            )
            estimatedHeight = 44
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 11.0, *) {
            label.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        } else {
            label.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    override func configure(with configuration: TableCellConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? Conf else {
            // Add a warning
            return
        }
        label.attributedText = conf.text
    }

}
