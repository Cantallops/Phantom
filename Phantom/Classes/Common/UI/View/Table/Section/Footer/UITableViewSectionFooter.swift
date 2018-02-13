//
//  UITableViewSectionFooter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

protocol UITableViewSectionFooter {
    var customView: UIView { get set }
    func height(forWidth width: CGFloat) -> CGFloat
}

extension UITableViewSectionFooter {
    func height(forWidth width: CGFloat) -> CGFloat {
        return customView.systemLayoutSizeFitting(CGSize(width: width, height: 0)).height
    }
}
