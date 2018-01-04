//
//  UIActivityIndicatorViewLoader.swift
//  Phantom
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView: Loader {
    var isLoading: Bool {
        return isAnimating
    }
    func start() {
        startAnimating()
    }
    func stop() {
        stopAnimating()
    }
}
