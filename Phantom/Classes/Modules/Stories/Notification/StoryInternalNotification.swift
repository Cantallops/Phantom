//
//  StoryInternalNotification.swift
//  Phantom
//
//  Created by Alberto Cantallops on 18/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

let storyInternalNotificationCenter = InternalNotificationCenter<Story>()

extension InternalNotification {
    static let StoryNew = InternalNotification(name: "NewTag")
    static let StoryEdit = InternalNotification(name: "EditTag")
    static let StoryDelete = InternalNotification(name: "DeleteTag")
}
