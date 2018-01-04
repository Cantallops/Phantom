//
//  MockPresenter.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 11/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
@testable import Phantom

class MockPresenter: PresenterProtocol {

    var didLoadHasBeenCalled = false
    func didLoad() {
        didLoadHasBeenCalled = true
    }

    var didLayoutSubviewsHasBeenCalled = false
    func didLayoutSubviews() {
        didLayoutSubviewsHasBeenCalled = true
    }

    var willAppearHasBeenCalled = false
    func willAppear() {
        willAppearHasBeenCalled = true
    }

    var didAppearHasBeenCalled = false
    func didAppear() {
        didAppearHasBeenCalled = true
    }

    var willDisappearHasBeenCalled = false
    func willDisappear() {
        willDisappearHasBeenCalled = true
    }

    var didDisappearHasBeenCalled = false
    func didDisappear() {
        didDisappearHasBeenCalled = true
    }

}
