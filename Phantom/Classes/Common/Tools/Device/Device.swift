//
//  Device.swift
//  Phantom
//
//  Created by Alberto Cantallops on 23/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

extension UIDevice {

    var isPad: Bool {
        return userInterfaceIdiom == .pad
    }

    var isPhone: Bool {
        return userInterfaceIdiom == .phone
    }
}
