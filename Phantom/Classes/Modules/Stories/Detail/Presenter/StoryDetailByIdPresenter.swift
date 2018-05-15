//
//  StoryDetailByIdPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 08/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class StoryDetailByIdPresenter: StoryDetailPresenter {
    var id: String?
    let getStoryById: Interactor<String, Story>

    init(
        id: String,
        userPreferences: Preferences,
        getStoryById: Interactor<String, Story>,
        createInteractor: Interactor<Story, Story>,
        editInteractor: Interactor<Story, Story>,
        deleteInteractor: Interactor<Story, Story>,
        publisherBuilder: Builder<PublisherArg, UIViewController>,
        settingsBuilder: Builder<StorySettingsArg, UIViewController>
    ) {
        self.id = id
        self.getStoryById = getStoryById
        super.init(
            story: nil,
            userPreferences: userPreferences,
            createInteractor: createInteractor,
            editInteractor: editInteractor,
            deleteInteractor: deleteInteractor,
            publisherBuilder: publisherBuilder,
            settingsBuilder: settingsBuilder
        )
    }

    override func willAppear() {
        super.willAppear()
        if let id = self.id {
            load(byID: id)
        }
    }

    func load(byID id: String) {
        async(loaders: [self], background: { [unowned self] in
            return self.getStoryById.execute(args: id)
        }, main: { [weak self] result in
            switch result {
            case .success(let story): self?.show(story: story)
            case .failure(let error): self?.show(error: error)
            }
        })
    }

    private func show(story: Story) {
        self.story = story
        self.initialStory = story
        self.setUpView(firstSave: false)
        self.id = nil
    }

}
