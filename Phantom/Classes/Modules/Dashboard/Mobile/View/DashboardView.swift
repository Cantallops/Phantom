//
//  DashboardView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

enum DashboardSection: Int {
    case stories
    case team
    case subscribers
    case settings
}

class DashboardView: UITabBarController {

    let presenter: Presenter<DashboardView>

    init(presenter: Presenter<DashboardView>) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad()
        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.willAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.didAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.willDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.didDisappear()
    }

    fileprivate func setUpUI() {
        view.backgroundColor = Color.white
        tabBar.backgroundColor = Color.white
        tabBar.barTintColor = Color.white
        tabBar.isTranslucent = true
    }

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        if let presented = presentedViewController {
            presented.present(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
}
