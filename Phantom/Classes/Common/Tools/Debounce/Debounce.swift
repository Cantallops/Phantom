//
//  Debounce.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class Debounce: NSObject {
    typealias Callback = (() -> Void)
    var callback: Callback
    var delay: Double
    weak var timer: Timer?

    init(delay: Double, callback: @escaping Callback) {
        self.delay = delay
        self.callback = callback
    }

    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(
            timeInterval: delay,
            target: self,
            selector: #selector(fire),
            userInfo: nil,
            repeats: false
        )
        timer = nextTimer
    }

    func reset() {
        call()
    }

    func invalidate() {
        timer?.invalidate()
    }

    @objc func fire() {
        self.callback()
    }
}
