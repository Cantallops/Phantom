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
        worker: Worker = AsyncWorker(),
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
            worker: worker,
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
        let task = Task(loaders: [self], task: { [unowned self] in
            return self.getStoryById.execute(args: id)
        }, completion: { [weak self] result in
            switch result {
            case .success(let story): self?.show(story: story)
            case .failure(let error): self?.show(error: error)
            }
        })
        worker.execute(task: task)
    }

    private func show(story: Story) {
        self.story = story
        self.initialStory = story
        self.setUpView(firstSave: false)
        self.id = nil
    }

}
