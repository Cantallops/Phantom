//
//  Button.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton {
    fileprivate var previousErrorTitle: String?
    fileprivate var previousErrorBackgroundColor: UIColor?
    fileprivate var isErrorMode: Bool!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        isErrorMode = false
        layer.cornerRadius = 4
        clipsToBounds = true
        backgroundColor = Color.tint
        setTitleColor(Color.white, for: .normal)
    }

    func setError(text: String? = nil) {
        if isErrorMode {
            return
        }
        isErrorMode = true
        previousErrorBackgroundColor = backgroundColor
        previousErrorTitle = title(for: .normal)
        backgroundColor = Color.red
        if let text = text {
            setTitle(text, for: .normal)
        }
    }

    func dismissError() {
        if !isErrorMode {
            return
        }
        isErrorMode = false
        backgroundColor = previousErrorBackgroundColor
        setTitle(previousErrorTitle, for: .normal)
    }

}

extension Button: Loader {
    private static let loadingTag = 9876
    var isLoading: Bool {
        return viewWithTag(Button.loadingTag) != nil
    }

    func start() {
        loading(show: true)
    }

    func stop() {
        loading(show: false)
    }

    fileprivate func loading(show: Bool) {
        isUserInteractionEnabled = !show
        if show && !isLoading {
            let indicator = UIActivityIndicatorView()
            indicator.tag = Button.loadingTag
            self.addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(
                item: indicator,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: titleLabel,
                attribute: .leading,
                multiplier: 1,
                constant: -5
            )
            let verticalConstraint = NSLayoutConstraint(
                item: indicator,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 0
            )
            self.addConstraints([horizontalConstraint, verticalConstraint])
            indicator.startAnimating()
        } else if isLoading {
            let indicator = viewWithTag(Button.loadingTag) as? UIActivityIndicatorView
            indicator?.stopAnimating()
            indicator?.removeFromSuperview()
        }
    }
}
