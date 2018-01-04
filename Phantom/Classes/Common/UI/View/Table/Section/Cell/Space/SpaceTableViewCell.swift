//
//  SpaceTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SpaceTableViewCell: TableViewCell {

    class Conf: TableCellConf {
        init(
            height: CGFloat = 20
        ) {
            super.init(
                identifier: "SpaceCell",
                nib: UINib(nibName: "SpaceTableViewCell", bundle: nil)
            )
            self.canSelect = false
            self.height = height
            self.estimatedHeight = 20
        }
    }

}
