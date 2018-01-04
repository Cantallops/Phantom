//
//  GetDashboardSections.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetDashboardSections: Interactor<Any?, [Dashboard.Section]> {

    private let getMe: Interactor<Any?, TeamMember>
    private let getGeneralSettings: DataSource<Any?, GeneralSettings>

    init(
        getMe: Interactor<Any?, TeamMember> = GetMe(),
        getGeneralSettings: DataSource<Any?, GeneralSettings> = GetGeneralSettings()
    ) {
        self.getMe = getMe
        self.getGeneralSettings = getGeneralSettings
        super.init()
    }

    override func execute(args: Any?) -> Result<[Dashboard.Section]> {
        let meResult = getMe.execute(args: nil)
        if let error = meResult.error {
            return .failure(error)
        }

        let generalSettingsResult = getGeneralSettings.execute(args: nil)
        if let error = generalSettingsResult.error {
            return .failure(error)
        }

        if let member = meResult.value, let generalSettings = generalSettingsResult.value {
            return .success(get(sectionsForUser: member, generalSettings: generalSettings))
        }
        return .failure(NetworkError(kind: .unknown))
    }

    private func get(sectionsForUser user: TeamMember, generalSettings: GeneralSettings) -> [Dashboard.Section] {
        let stories = Dashboard.Section(
            kind: .story,
            name: "Content",
            icon: #imageLiteral(resourceName: "ic_tab_stories"),
            selectedIcon: #imageLiteral(resourceName: "ic_tab_stories_selected"),
            factory: StoriesListFactory(),
            nav: true
        )
        let team = Dashboard.Section(
            kind: .team,
            name: "Team",
            icon: #imageLiteral(resourceName: "ic_tab_team"),
            selectedIcon: #imageLiteral(resourceName: "ic_tab_team_selected"),
            factory: TeamListFactory(),
            nav: true
        )
        var sections: [Dashboard.Section] = [stories, team]

        if (user.role == .administrator || user.role == .owner) && generalSettings.isSubscribersEnabled {
            let subscribersList = Dashboard.Section(
                kind: .subscribers,
                name: "Subscribers",
                icon: #imageLiteral(resourceName: "ic_tab_subscribers"),
                selectedIcon: #imageLiteral(resourceName: "ic_tab_subscribers_selected"),
                factory: SubscribersListFactory(),
                nav: true
            )
            sections.append(subscribersList)
        }
        let more = Dashboard.Section(
            kind: .more,
            name: "More",
            icon: #imageLiteral(resourceName: "ic_tab_more"),
            selectedIcon: #imageLiteral(resourceName: "ic_tab_more_selected"),
            factory: MoreFactory(),
            nav: true
        )
        sections.append(more)

        return sections
    }
}
