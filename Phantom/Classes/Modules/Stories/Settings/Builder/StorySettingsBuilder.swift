//
//  StorySettingsBuilder.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

typealias StorySettingsArg = (story: Story, onEdit: OnEditStoryAction, onDelete: OnDeleteStoryAction)

class StorySettingsBuilder: Builder<StorySettingsArg, UIViewController> {
    override func build(arg: StorySettingsArg) -> UIViewController {
        let presenter = StorySettingsPresenter(
            story: arg.story,
            onEdit: arg.onEdit,
            onDelete: arg.onDelete,
            getTags: GetTagListInteractor(getTagListDataSource: GetTagListRemote()),
            getMembers: GetMembersInteractor(getMembersRemote: GetTeamRemote()),
            getMe: GetMeInteractor(getMeRemote: GetMeRemote()),
            metaDataBuilder: MetaDataBuilder(),
            getTemplates: GetCurrentTemplatesInteractor()
        )
        let view = StorySettingsView(presenter: presenter)
        presenter.view = view

        return view
    }
}
