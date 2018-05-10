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

    private let getStories: Interactor<Meta?, Paginated<[Story]>>
    private let indexStories: Interactor<([Story], Account), Any?>
    private let removeIndexStories: Interactor<Account, Any?>

    private var observers: [NSObjectProtocol] = []

    init(
        getStories: Interactor<Meta?, Paginated<[Story]>> = GetStoriesListInteractor(),
        indexStories: Interactor<([Story], Account), Any?> = IndexStoriesInteractor(),
        removeIndexStories: Interactor<Account, Any?> = RemoveIndexStoriesInteractor()
    ) {
        self.getStories = getStories
        self.indexStories = indexStories
        self.removeIndexStories = removeIndexStories
        super.init()
        setUpObservers()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if let account = Account.current {
            if account.preferences.indexStories {
                doIndexStories(account: account)
            } else {
                doRemoveIndexStories(account: account)
            }
        }
        return true
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]?) -> Void
    ) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType,
            let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
            let storyId = uniqueIdentifier.components(separatedBy: "~").first,
            let account = Account.current,
            account.loggedIn,
            account.identifier == uniqueIdentifier.components(separatedBy: "~").last {
            openStory(withId: storyId, app: application)
        }
        return true
    }

    private func openStory(withId id: String, app: UIApplication) {
        let storyView = StoryDetailBuilderById().build(arg: id)
        let nav = NavigationController(rootViewController: storyView)
        app.keyWindow?.rootViewController?.present(nav, animated: true)
    }

    private func setUpObservers() {
        let indexStoriesObserver = indexStoriesNotificationCenter.addObserver(
            forType: .indexStories
        ) { [unowned self] index in
            if let account = Account.current {
                if index {
                    self.doIndexStories(account: account)
                } else {
                    self.doRemoveIndexStories(account: account)
                }
            }
        }

        let signOutObserver = sessionNotificationCenter.addObserver(forType: .signOut) { [unowned self] account in
            if let account = account {
                self.doRemoveIndexStories(account: account)
            }
        }

        observers = [indexStoriesObserver, signOutObserver]

    }

    private func doIndexStories(account: Account) {
        async(background: {
            let result = self.getStories.execute(args: nil)
            let args = (result.value?.object ?? [], account)
            self.indexStories.execute(args: args)
        })
    }

    private func doRemoveIndexStories(account: Account) {
        async(background: { self.removeIndexStories.execute(args: account) })
    }
}
