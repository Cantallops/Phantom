//
//  RightDetailTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 28/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class RightDetailTableViewCell: TableViewCell {
    class Conf: TableCellConf {
        var text: String?
        var rightText: String?
        var image: UIImage?

        init(
            text: String? = nil,
            rightText: String? = nil,
            image: UIImage? = nil
        ) {
            self.text = text
            self.rightText = rightText
            self.image = image
            super.init(
                identifier: "RightDetailCell",
                nib: UINib(nibName: "RightDetailTableViewCell", bundle: nil)
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

        guard let object = configuration as? Conf else {
            // Add a warning
            return
        }
        textLabel?.text = object.text
        detailTextLabel?.text = object.rightText
        imageView?.image = object.image
    }
}
