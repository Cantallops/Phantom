//
//  TextView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

@IBDesignable
class TextView: UITextView {

    typealias OnWriteClosure = ((String?) -> Void)?
    typealias OnBecomeFirstResponder = (() -> Void)?
    typealias OnResignFirstResponder = (() -> Void)?
    typealias OnScrollClosure = ((UIScrollView) -> Void)?
    typealias OnEnterClosure = (() -> Bool)?

    var onWrite: OnWriteClosure
    var onBecomeFirstResponder: OnBecomeFirstResponder
    var onResignFirstResponder: OnResignFirstResponder
    var onScroll: OnScrollClosure
    var onEnter: OnEnterClosure

    var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }
    override var text: String! {
        didSet {
            uploadPlaceholder()
        }
    }
    override var font: UIFont? {
        didSet {
            placeholderLabel?.font = font
        }
    }
    override var textContainerInset: UIEdgeInsets {
        didSet {
            placeholderLabel?.textContainerInset = textContainerInset
        }
    }
    private weak var placeholderLabel: UITextView!

    fileprivate var previousBorderColor: CGColor?
    fileprivate var isErrorMode: Bool!

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
        setUpPlaceholderLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel?.frame = bounds
    }

    private func setUpPlaceholderLabel() {
        let textView = UITextView(frame: bounds)
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.textColor = Color.placeholder
        textView.font = font
        textView.textContainerInset = textContainerInset
        insertSubview(textView, at: 0)
        placeholderLabel = textView
        uploadPlaceholder()
    }

    private func uploadPlaceholder() {
        placeholderLabel.isHidden = !text.isEmpty
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

extension TextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onWrite?(textView.text)
        uploadPlaceholder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        onWrite?(textView.text)
        uploadPlaceholder()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let onEnter = onEnter, text == "\n" {
            return onEnter()
        }
        return true
    }
}

extension TextView {
    func wrap(selectedTextWith wrapperLeft: String, wrapperRight: String? = nil) {
        guard let range = selectedTextRange else {
            return
        }
        var selectedText = text(in: range) ?? ""
        selectedText = "\(wrapperLeft)\(selectedText)\(wrapperRight ?? wrapperLeft)"
        replace(range, withText: selectedText)
        let currentStartPosition = range.start
        let currentEndPosition = range.end
        if let startPosition = position(from: currentStartPosition, offset: wrapperLeft.count),
            let endPosition = position(from: currentEndPosition, offset: wrapperLeft.count) {
            selectedTextRange = textRange(from: startPosition, to: endPosition)
        }
    }

    func wrap(selectedLineWith wrapperLeft: String, wrapperRight: String? = nil, max: Int? = nil) {
        guard let range = selectedTextRange else {
            return
        }
        let currentPosition = range.start
        guard let startOfLine = tokenizer.position(
                from: currentPosition,
                toBoundary: .paragraph,
                inDirection: UITextStorageDirection.backward.rawValue
            ),
            let endOfLine = tokenizer.position(
                from: currentPosition,
                toBoundary: .paragraph,
                inDirection: UITextStorageDirection.forward.rawValue
            ),
            let rangeToWrap = textRange(from: startOfLine, to: endOfLine) else {
            return
        }
        let initialText = text(in: rangeToWrap) ?? ""
        var newText = "\(wrapperLeft)\(initialText)\(wrapperRight ?? wrapperLeft)"
        if let max = max {
            var trimmedWrapperLeft = wrapperLeft.trimmingCharacters(in: .whitespacesAndNewlines)
            var maxPrefix = wrapperLeft
            for _ in 0..<max-1 {
                maxPrefix = "\(trimmedWrapperLeft)\(maxPrefix)"
            }
            if !initialText.hasPrefix(trimmedWrapperLeft) {
                trimmedWrapperLeft = wrapperLeft
            }
            if initialText.hasPrefix(maxPrefix) {
                let index = initialText.index(initialText.startIndex, offsetBy: maxPrefix.count)
                newText = "\(initialText[index...])\(wrapperRight ?? wrapperLeft)"
            } else {
                newText = "\(trimmedWrapperLeft)\(initialText)\(wrapperRight ?? wrapperLeft)"
            }
        }

        replace(rangeToWrap, withText: newText)
        if let newPosition = position(from: range.end, offset: newText.count - initialText.count) {
            selectedTextRange = textRange(from: newPosition, to: newPosition)
        }

    }
}

extension TextView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScroll?(scrollView)
    }
}

extension TextView {
    func setTextKeepingSelection(_ text: String) {
        let range = selectedTextRange
        self.text = text
        if let range = range {
            selectedTextRange = textRange(from: range.start, to: range.end)
        }
    }
}
