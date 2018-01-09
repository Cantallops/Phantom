//
//  TagDetailView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TagDetailView: TableViewController {

    var onTapSave: (() -> Void)?
    var enableSaveButton: Bool = true {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = enableSaveButton
        }
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        if #available(iOS 11.0, *), UIDevice.current.userInterfaceIdiom == .pad {
            navigationItem.largeTitleDisplayMode = .never
        }
        setUpSaveButton()
    }

    private func setUpSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(tapSave)
        )
        navigationItem.rightBarButtonItem?.isEnabled = enableSaveButton
    }

    override func setUpTable() {
        super.setUpTable()
        tableView.backgroundColor = Color.lighterGrey
    }

    @objc private func tapSave() {
        onTapSave?()
    }
}

extension TagDetailView: Loader {
    var isLoading: Bool {
        return navigationItem.rightBarButtonItem?.customView is UIActivityIndicatorView
    }

    func start() {
        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
    }

    func stop() {
        setUpSaveButton()
    }
}
