//
//  SignInPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SignInPresenter: Presenter<SignInView> {
    private let worker: Worker
    private let doCredentialSignIn: Interactor<Credentials, Any?>

    init(
        worker: Worker = AsyncWorker(),
        doCredentialSignIn: Interactor<Credentials, Any?> = DoCredentialSignInInteractor()
    ) {
        self.worker = worker
        self.doCredentialSignIn = doCredentialSignIn
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        view.onTapSignInButton = doSignIn
        view.emailField.text = Account.last?.username
    }

    private func doSignIn(withCredentials credentials: SignInView.Credentials) {
        guard let email = credentials.email,
              let pass = credentials.password,
            !email.isEmpty, !pass.isEmpty else {
            show(error: Errors.Form.notFilled)
            return
        }
        let signInCredentials = Credentials(email: email, password: pass)
        let task = Task(loaders: [view.signInButton], qos: .userInitiated, task: { [unowned self]  in
                self.doCredentialSignIn.execute(args: signInCredentials)
        }, completion: { [unowned self] result in
            switch result {
            case .success: self.goToDashboard()
            case .failure(let error): self.show(error: error)
            }
        })
        worker.execute(task: task)
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
