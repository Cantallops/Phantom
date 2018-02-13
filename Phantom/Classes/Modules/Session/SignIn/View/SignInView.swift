//
//  SignInView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SignInView: ViewController {

    struct Credentials {
        let email: String?
        let password: String?
    }

    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var signInButton: Button!
    @IBOutlet weak var errorLabel: Label!

    var onTapSignInButton: ((SignInView.Credentials) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.textColor = Color.red
        emailField.onReturn = tabToPasswordField
        passwordField.onReturn = onTapSignIn
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    fileprivate func tabToPasswordField() {
        passwordField.becomeFirstResponder()
    }

    @IBAction func onTapSignIn() {
        let credentials = SignInView.Credentials(
            email: emailField.text,
            password: passwordField.text
        )
        onTapSignInButton?(credentials)
    }

    func show(error: String) {
        errorLabel.text = error
        emailField.setError()
        passwordField.setError()
        signInButton.setError(text: "Retry")
    }

    func clearError() {
        errorLabel.text = nil
        emailField.dismissError()
        passwordField.dismissError()
        signInButton.dismissError()
    }
}
