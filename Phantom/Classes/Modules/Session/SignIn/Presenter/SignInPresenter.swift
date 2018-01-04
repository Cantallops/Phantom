//
//  SignInPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SignInPresenter: Presenter<SignInView> {
    private let doCredentialSignIn: Interactor<Credentials, Any?>
    private let doBiometricSignIn: Interactor<Any?, Any?>
    private let getBiometricSupport: Interactor<Any?, BiometricType>

    init(
        doCredentialSignIn: Interactor<Credentials, Any?> = DoCredentialSignIn(),
        doBiometricSignIn: Interactor<Any?, Any?> = DoBiometricSignIn(),
        getBiometricSupport: Interactor<Any?, BiometricType> = GetBiometricSupport()
    ) {
        self.doCredentialSignIn = doCredentialSignIn
        self.doBiometricSignIn = doBiometricSignIn
        self.getBiometricSupport = getBiometricSupport
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        setBiometricSupport()
        view.onTapSignInButton = doSignIn
        view.emailField.text = Account.last?.username
    }

    private func setBiometricSupport() {
        view.removeBiometric() // FIX WHEN IMPLEMENT BIOMETRIC LOGIN
        switch getBiometricSupport.execute(args: nil) {
        case .success(let type):
            switch type {
            case .touchID:
                return
            case .faceID:
                view.removeBiometric()
            case .none:
                view.removeBiometric()
            }
        default:
            view.removeBiometric()
        }
    }

    private func doSignIn(withCredentials credentials: SignInView.Credentials) {
        guard let email = credentials.email,
              let pass = credentials.password,
            !email.isEmpty, !pass.isEmpty else {
            show(error: Errors.Form.notFilled)
            return
        }
        let signInCredentials = Credentials(email: email, password: pass)
        async(
            loaders: [view.signInButton],
            background: { [unowned self]  in
                self.doCredentialSignIn.execute(args: signInCredentials)
        }, main: { [unowned self] result in
            switch result {
            case .success: self.goToDashboard()
            case .failure(let error): self.show(error: error)
            }
        })
    }

    private func goToDashboard() {
        view.clearError()
        view.navigationController?.dismiss(animated: true, completion: nil)
    }

    override func show(error: Error) {
        var errorDescription = error.localizedDescription
        if let error = error as? NetworkError {
            errorDescription = error.localizedDescription
        }
        view.show(error: errorDescription)
    }
}
