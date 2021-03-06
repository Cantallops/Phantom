//
//  ViewController.swift
//  Phantom
//
//  Created by Alberto Cantallops on 10/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Presentable {
    var presenter: PresenterProtocol
    var scrollToViewWhenKeyboardShows: Bool = true

    fileprivate var observers: [NSObjectProtocol] = []

    init(presenter: PresenterProtocol) {
        self.presenter = presenter
        var nibName: String? = String(describing: type(of: self))
        if nibName == String(describing: ViewController.self) {
            nibName = nil
        }
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented. You must use init(presenter:) instead")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        presenter.didLoad()
        setUpNavigation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter.didLayoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.willAppear()
        let keyboardDidShowObserver = NotificationCenter.default.addObserver(
            forName: .UIKeyboardDidShow,
            object: nil,
            queue: nil,
            using: keyboardDidShow
        )
        observers.append(keyboardDidShowObserver)
        let keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: .UIKeyboardWillShow,
            object: nil,
            queue: nil,
            using: keyboardWillBeShown
        )
        observers.append(keyboardWillShowObserver)
        let keyboardFrameChangeObserver = NotificationCenter.default.addObserver(
            forName: .UIKeyboardWillChangeFrame,
            object: nil,
            queue: nil,
            using: keyboardFrameChange
        )
        observers.append(keyboardFrameChangeObserver)
        let keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: .UIKeyboardWillHide,
            object: nil,
            queue: nil,
            using: keyboardWillBeHidden
        )
        observers.append(keyboardWillHideObserver)
        let keyboardDidHideObserver = NotificationCenter.default.addObserver(
            forName: .UIKeyboardDidHide,
            object: nil,
            queue: nil,
            using: keyboardDidHide
        )
        observers.append(keyboardDidHideObserver)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.didAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.willDisappear()
        removeObservers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.didDisappear()
    }

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        if let nav = navigationController {
            nav.present(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }

    func setUpNavigation() {
    }

    private func removeObservers() {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
        observers.removeAll()
    }

    func keyboard(frame: CGRect) {
        recalculateScrollViewInsets(frame: frame)
    }
    func keyboardWillShown() {}
    func keyboardShown() {}
    func keyboardWillHide() {}
    func keyboardHide() {}
}

extension ViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc fileprivate func keyboardFrameChange(notification: Notification) {
        if let userInfo = notification.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            keyboard(frame: rect)
        }
    }

    @objc private func keyboardWillBeShown(notification: Notification) {
        keyboardWillShown()
    }

    @objc private func keyboardDidShow(notification: Notification) {
        if let userInfo = notification.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            keyboard(frame: rect)
        }
        keyboardShown()
    }

    @objc private func keyboardDidHide(notification: Notification) {
        keyboard(frame: .zero)
        keyboardHide()
    }

    @objc private func keyboardWillBeHidden(notification: Notification) {
        keyboard(frame: .zero)
        keyboardWillHide()
    }

    private func recalculateScrollViewInsets(frame: CGRect) {
        guard let scrollView = view.findScrollView(maxDeep: 0) else {
            return
        }
        var contentInset = scrollView.contentInset
        contentInset.bottom = scrollView.frame.intersection(frame).height
        if let navBar = navigationController?.navigationBar, !navBar.isTranslucent, contentInset.bottom != 0 {
            contentInset.bottom += navBar.frame.maxY
        }

        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset

        guard let firstResponder = view.findFirstResponder() else {
            return
        }
        let convertedFrame = firstResponder.convert(firstResponder.frame, to: scrollView)
        if !scrollToViewWhenKeyboardShows {
            return
        }
        var aRect = view.frame
        aRect.size.height -= frame.size.height
        let contains = aRect.contains(CGPoint(x: 0, y: convertedFrame.origin.y + convertedFrame.size.height))
        if (!aRect.contains(convertedFrame.origin) || !contains) && !(scrollView is UITextView) {
            scrollView.scrollRectToVisible(convertedFrame, animated: true)
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            return !view.isKind(of: UIControl.self)
        }
        return true
    }
}
