//
//  TagInternalNotification.swift
//  Phantom
//
//  Created by Alberto Cantallops on 18/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

let tagInternalNotificationCenter = InternalNotificationCenter<Tag>()

extension InternalNotification {
    static let tagNew = InternalNotification(name: "NewTag")
    static let tagEdit = InternalNotification(name: "EditTag")
    static let tagDelete = InternalNotification(name: "DeleteTag")
}
