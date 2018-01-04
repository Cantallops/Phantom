//
//  EmptyTableSectionFooter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

struct EmptyTableSectionFooter: UITableViewSectionFooter {
    var customView: UIView
    private let height: CGFloat

    init(height: CGFloat) {
        self.height = height
        customView = UIView()
    }

    func height(forWidth width: CGFloat) -> CGFloat {
        return height
    }
}
