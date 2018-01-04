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
    static let TagNew = InternalNotification(name: "NewTag")
    static let TagEdit = InternalNotification(name: "EditTag")
    static let TagDelete = InternalNotification(name: "DeleteTag")
}
