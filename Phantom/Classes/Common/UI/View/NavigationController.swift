//
//  NavigationController.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        navigationBar.barTintColor = Color.white
        toolbar.tintColor = Color.tint
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fixShadowImage(inView: view)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        viewController.navigationItem.backBarButtonItem = backItem
    }

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        if let tabBar = tabBarController {
            tabBar.present(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }

    private func fixShadowImage(inView view: UIView) {
        if let imageView = view as? UIImageView {
            let size = imageView.bounds.size.height
            if size <= 1 && size > 0 && imageView.subviews.count == 0,
                let components = imageView.backgroundColor?.cgColor.components, components == [0, 0, 0, 0.3] {
                let forcedBackground = UIView(frame: imageView.bounds)
                forcedBackground.backgroundColor = .white
                imageView.addSubview(forcedBackground)
                forcedBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            }
        }
        for subview in view.subviews {
            fixShadowImage(inView: subview)
        }
    }
}
