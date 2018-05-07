//
//  SearcheableIndexService.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit
import CoreSpotlight

class SearcheableIndexService: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]?) -> Void
    ) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType,
            let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            openStory(withId: uniqueIdentifier, app: application)
        }
        return true
    }

    private func openStory(withId id: String, app: UIApplication) {
        let storyView = StoryDetailBuilderById().build(arg: id)
        let nav = NavigationController(rootViewController: storyView)
        app.keyWindow?.rootViewController?.present(nav, animated: true)
    }
}
