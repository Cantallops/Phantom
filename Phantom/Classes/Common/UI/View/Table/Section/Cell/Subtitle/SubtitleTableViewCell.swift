//
//  SubtitleTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: TableViewCell {

    class Conf: TableCellConf {
        var text: String?
        var subtitle: String?
        var image: UIImage?
        var cornerRadius: CGFloat

        init(
            text: String? = nil,
            subtitle: String? = nil,
            image: UIImage? = nil,
            cornerRadius: CGFloat = 0
        ) {
            self.text = text
            self.subtitle = subtitle
            self.image = image
            self.cornerRadius = cornerRadius
            super.init(
                identifier: "SubtitleCell",
                nib: UINib(nibName: "SubtitleTableViewCell", bundle: nil)
            )
            self.estimatedHeight = 44
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
        detailTextLabel?.text = conf.subtitle
        imageView?.image = conf.image
        imageView?.layer.cornerRadius = conf.cornerRadius
        imageView?.layer.masksToBounds = true
    }

}
