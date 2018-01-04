//
//  InternalNotification.swift
//  Phantom
//
//  Created by Alberto Cantallops on 18/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct InternalNotification {
    let name: String
}

class InternalNotificationCenter<T> {
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
    }

    func post(_ notification: InternalNotification, object: T, userInfo: [AnyHashable: Any] = [:]) {
        let notificationName = NSNotification.Name(rawValue: notification.name)
        notificationCenter.post(name: notificationName, object: object, userInfo: userInfo)
    }

    func addObserver(
        forType notification: InternalNotification,
        using block: @escaping (T) -> Void
    ) -> NSObjectProtocol {
        let notificationName = NSNotification.Name(rawValue: notification.name)
        return notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
            if let object = notification.object,
                let obj = object as? T {
                DispatchQueue.main.async(execute: {
                    block(obj)
                })
            }
        }
    }

    func remove(observer: NSObjectProtocol) {
        notificationCenter.removeObserver(observer)
    }
}
