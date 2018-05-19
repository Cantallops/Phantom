//
//  BlogSiteView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 10/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class BlogSiteView: ViewController {

    @IBOutlet weak var urlField: TextField!
    @IBOutlet weak var goButton: Button!
    @IBOutlet weak var errorLabel: Label!
    var onTapAbout: (() -> Void)?

    var onTapButton: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.onReturn = onTapGoButton
        errorLabel.textColor = Color.red
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        title = "Ghost blog address"
    }

    @IBAction func onTapGoButton() {
        let text = urlField.text
        onTapButton?(text)
    }

    @IBAction func onTapAboutButton() {
        onTapAbout?()
    }

    func show(error: String) {
        errorLabel.text = error
        urlField.setError()
        goButton.setError(text: "Retry")
    }

    func clearError() {
        errorLabel.text = nil
        urlField.dismissError()
        goButton.dismissError()
    }
}
