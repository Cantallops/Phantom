//
//  Presenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

protocol Presentable: class {
    var presenter: PresenterProtocol { get set }
}

protocol PresenterProtocol: class {
    func didLoad()
    func didLayoutSubviews()
    func willAppear()
    func didAppear()
    func willDisappear()
    func didDisappear()
}

class Presenter<VC: UIViewController>: PresenterProtocol {
    weak var view: VC!
    lazy fileprivate var basicLoader: UIActivityIndicatorView = {
        let frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        let activity = UIActivityIndicatorView(frame: frame)
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.color = Color.tint
        activity.backgroundColor = Color.lightGrey
        activity.layer.cornerRadius = 4
        activity.hidesWhenStopped = true
        return activity
    }()

    init() {}

    func didLoad() {}
    func didLayoutSubviews() {
        reloadLoadingFrame()
    }
    func willAppear() {
        basicLoader.removeFromSuperview()
        view.view.addSubview(basicLoader)
    }
    func didAppear() {}
    func willDisappear() {}
    func didDisappear() {}

    func show(error: Error) {
        if error.isUnauthorized || error.cannotConnect {
            sessionNotificationCenter.post(.signOut, object: Account.current)
            return
        }
        let alert = UIAlertController(
            title: "Something was wrong",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view.present(alert, animated: true)
    }
}

extension Presenter: Loader {
    var isLoading: Bool {
        return basicLoader.isLoading
    }

    func start() {
        basicLoader.start()
    }

    func stop() {
        basicLoader.stop()
    }

    private func reloadLoadingFrame() {
        basicLoader.frame = CGRect(
            x: view.view.frame.width/2 - 50,
            y: view.view.frame.height/2 - 50,
            width: 100,
            height: 100)
    }
}
