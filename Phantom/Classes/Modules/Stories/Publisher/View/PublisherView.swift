//
//  PublisherView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class PublisherView: ViewController {

    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cancelButton: Button!
    @IBOutlet private weak var acceptButton: Button!
    @IBOutlet private weak var contentStack: UIStackView!
    private var errorLabel: Label?

    // swiftlint:disable:next weak_delegate
    private var fullDelegate: UITableViewFullDelegate?

    var acceptLoader: Loader {
        return acceptButton
    }
    var onAccept: (() -> Void)?
    var sections: [UITableView.Section] = [] {
        didSet {
            fullDelegate?.sections = sections
            resize()
        }
    }

    override var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }

    private var canActivateAnchor = false
    private var height: CGFloat? {
        didSet {
            heightAnchor?.isActive = false
            if let height = height, canActivateAnchor {
                heightAnchor = view.heightAnchor.constraint(equalToConstant: height)
                heightAnchor?.identifier = "HOLA"
                print("Active height: \(height)")
                heightAnchor?.isActive = true
            }
        }
    }
    private var heightAnchor: NSLayoutConstraint?
    var acceptTitle: String? {
        didSet {
            acceptButton.setTitle(acceptTitle, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpView()
        removeError()
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        canActivateAnchor = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var labelHeight: CGFloat = 0
        if let errorLabel = errorLabel, let text = errorLabel.text {
            labelHeight = text.height(withConstrainedWidth: view.frame.width, font: errorLabel.font)
        }
        height = 20 + 25 + 10 + tableView.contentSize.height * 1.1 + 10 + 44 + 15 + labelHeight
    }

    private func setUpTable() {
        fullDelegate = UITableViewFullDelegate()
        tableView.fullDelegate = fullDelegate
        fullDelegate?.sections = sections
        tableView.tableFooterView = UIView()
    }

    private func setUpView() {
        titleLabel.text = title
        cancelButton.backgroundColor = Color.lightGrey
        cancelButton.setTitleColor(UIColor.darkText, for: .normal)
        acceptButton.backgroundColor = Color.green
        acceptButton.setTitle(acceptTitle, for: .normal)
    }

    @IBAction func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func tapAccept() {
        onAccept?()
        removeError()
    }

    func setError(_ error: String) {
        removeError()
        let errorLabel = Label()
        errorLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        errorLabel.text = error
        errorLabel.textColor = Color.red
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        self.errorLabel = errorLabel
        contentStack.addArrangedSubview(errorLabel)
        acceptButton.setError()
        resize()
    }

    func removeError() {
        errorLabel?.text = nil
        errorLabel?.removeFromSuperview()
        acceptButton.dismissError()
        resize()
    }

    private func resize() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
