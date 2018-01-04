//
//  XCTestCase+Helper.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 12/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

extension XCTestCase {
    func set(rootViewController: UIViewController) {
        for window in UIApplication.shared.windows {
            window.rootViewController = nil
        }
        let window = UIWindow()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
