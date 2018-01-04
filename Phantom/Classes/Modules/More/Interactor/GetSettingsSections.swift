//
//  GetSettingsSections.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class GetSettingsSections: Interactor<Any?, [UIViewController]> {

    private let getMe: Interactor<Any?, TeamMember>

    private let generalSettingsFactory: Factory<UIViewController>
    private let designFactory: Factory<UIViewController>
    private let tagsListFactory: Factory<UIViewController>
    private let codeInjectionFactory: Factory<UIViewController>
    private let appsFactory: Factory<UIViewController>
    private let labsFactory: Factory<UIViewController>

    init(
        getMe: Interactor<Any?, TeamMember> = GetMe(),
        generalSettingsFactory: Factory<UIViewController> = GeneralSettingsFactory(),
        designFactory: Factory<UIViewController> = DesignFactory(),
        tagsListFactory: Factory<UIViewController> = TagsListFactory(),
        codeInjectionFactory: Factory<UIViewController> = CodeInjectionFactory(),
        appsFactory: Factory<UIViewController> = AppsFactory(),
        labsFactory: Factory<UIViewController> = LabsFactory()
    ) {
        self.getMe = getMe
        self.generalSettingsFactory = generalSettingsFactory
        self.designFactory = designFactory
        self.tagsListFactory = tagsListFactory
        self.codeInjectionFactory = codeInjectionFactory
        self.appsFactory = appsFactory
        self.labsFactory = labsFactory
        super.init()
    }

    override func execute(args: Any?) -> Result<[UIViewController]> {
        let meResult = getMe.execute(args: nil)
        switch meResult {
        case .failure(let error):
            return .failure(error)
        case .success(let member):
            return .success(get(sectionsForUser: member))
        }
    }

    private func get(sectionsForUser user: TeamMember) -> [UIViewController] {
        switch user.role {
        case .author:
            return []
        case .editor:
            return [tagsListFactory.build()]
        default:
            return [
                tagsListFactory.build()
            ]
        }
    }
}
