//
//  UIViewUtils.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

public extension UIView {
    func findFirstResponder(maxDeep: UInt = UInt.max) -> UIView? {
        for subview in subviews {
            if subview.isFirstResponder {
                return subview
            }
            if maxDeep > 0, let recursiveSubview = subview.findFirstResponder(maxDeep: maxDeep-1) {
                return recursiveSubview
            }
        }

        return nil
    }

    func findScrollView(maxDeep: UInt = UInt.max) -> UIScrollView? {
        for subview in subviews {
            if let scrollView = subview as? UIScrollView {
                return scrollView
            }
            if maxDeep > 0, let scrollView = subview.findScrollView(maxDeep: maxDeep-1) {
                return scrollView
            }
        }
        return nil
    }
}

public extension UIView {
    func loadViewFromNib(name: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError()
        }
        return view
    }
}
