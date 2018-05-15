//
//  BlogSitePresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class BlogSitePresenter: Presenter<BlogSiteView> {

    private let worker: Worker
    private let detectGhostInstallation: Interactor<URL, String>
    private let signInFactory: Factory<UIViewController>

    init(
        worker: Worker = AsyncWorker(),
        detectGhostInstallation: Interactor<URL, String> = DetectGhostInstallationInteractor(),
        signInFactory: Factory<UIViewController> = SignInFactory()
    ) {
        self.worker = worker
        self.detectGhostInstallation = detectGhostInstallation
        self.signInFactory = signInFactory
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        view.onTapButton = detectGhost
        if let lastAccount = Account.last {
            view.urlField.text = lastAccount.blogUrl
            detectGhost(urlString: lastAccount.blogUrl)
        }
    }

    private func detectGhost(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            show(error: Errors.Form.notFilled)
            return
        }
        let task = Task(loaders: [view.goButton], task: { [unowned self]  in
                self.detectGhostInstallation.execute(args: url)
        }, completion: { [unowned self] result in
            switch result {
            case .success(let title): self.goToLogin(withTitle: title)
            case .failure(let error): self.show(error: error)
            }
        })
        worker.execute(task: task)
    }

    private func goToLogin(withTitle title: String) {
        view.clearError()
        let signInView = signInFactory.build()
        signInView.title = title
        view.navigationController?.pushViewController(signInView, animated: true)

    }

    override func show(error: Error) {
        var errorDescription = error.localizedDescription
        if let error = error as? NetworkError {
            if error.kind == .unknown {
                errorDescription = "It has been impossible detect a Ghost installation"
            }
        }
        view.show(error: errorDescription)
    }
}
