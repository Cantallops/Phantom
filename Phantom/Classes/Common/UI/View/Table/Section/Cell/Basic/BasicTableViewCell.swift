//
//  BasicTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 27/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class BasicTableViewCell: TableViewCell {

    class Conf: TableCellConf {
        var text: String?
        var attributedText: NSAttributedString?
        var textColor: UIColor?
        var textFont: UIFont?
        var image: UIImage?

        init(
            text: String? = nil,
            attributedText: NSAttributedString? = nil,
            textColor: UIColor? = nil,
            textFont: UIFont? = nil,
            image: UIImage? = nil
        ) {
            self.text = text
            self.attributedText = attributedText
            self.textColor = textColor
            self.textFont = textFont
            self.image = image
            super.init(
                identifier: "BasicCell",
                nib: UINib(nibName: "BasicTableViewCell", bundle: nil)
            )
            estimatedHeight = 44
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

    override func configure(with configuration: TableCellConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? Conf else {
            // Add a warning
            return
        }
        textLabel?.text = conf.text
        if let attributedText = conf.attributedText {
            textLabel?.attributedText = attributedText
        }
        textLabel?.textColor = conf.textColor
        textLabel?.font = conf.textFont
        imageView?.image = conf.image
    }
}
