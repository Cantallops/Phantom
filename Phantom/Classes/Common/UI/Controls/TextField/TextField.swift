//
//  TextField.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

@IBDesignable
class TextField: UITextField {

    typealias OnReturnClosure = (() -> Void)?
    typealias OnWriteClosure = ((String?) -> Void)?
    typealias OnBecomeFirstResponder = (() -> Void)?
    typealias OnResignFirstResponder = (() -> Void)?

    var onReturn: OnReturnClosure
    var onWrite: OnWriteClosure
    var onBecomeFirstResponder: OnBecomeFirstResponder
    var onResignFirstResponder: OnResignFirstResponder

    fileprivate var previousBorderColor: CGColor?
    fileprivate var isErrorMode: Bool!
    var disableActionsEditing: Bool = false

    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [.foregroundColor: Color.placeholder]
            )
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    fileprivate func initialize() {
        isErrorMode = false
        delegate = self
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = Color.border.cgColor
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }

    override func resignFirstResponder() -> Bool {
        let resign = super.resignFirstResponder()
        if resign {
            onResignFirstResponder?()
        }
        return resign
    }

    @discardableResult override func becomeFirstResponder() -> Bool {
        let become = super.becomeFirstResponder()
        if become {
            onBecomeFirstResponder?()
        }
        return become
    }

    @objc private func textFieldDidChange() {
        onWrite?(text)
    }

    @objc private func textFieldDidEndEditing() {
        onWrite?(text)
    }

    func setError() {
        if isErrorMode {
            return
        }
        isErrorMode = true
        previousBorderColor = layer.borderColor
        layer.borderColor = Color.red.cgColor
    }

    func dismissError() {
        if !isErrorMode {
            return
        }
        isErrorMode = false
        layer.borderColor = previousBorderColor
    }
}

extension TextField: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?()
        return false
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        if disableActionsEditing {
            return .zero
        }
        return super.caretRect(for: position)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if disableActionsEditing {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

}
