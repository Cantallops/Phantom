//
//  StoryDetailBuilder.swift
//  Phantom
//
//  Created by Alberto Cantallops on 10/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class StoryDetailBuilder: Builder<Story?, ViewController> {
    override func build(arg: Story?) -> ViewController {
        let presenter = StoryDetailPresenter(
            story: arg,
            createInteractor: CreateStoryInteractor(createRemote: PostStoryRemote()),
            editInteractor: EditStoryInteractor(editRemote: PutStoryRemote()),
            deleteInteractor: DeleteStoryInteractor(deleteRemote: DeleteStoryRemote()),
            publisherBuilder: PublisherBuilder(),
            settingsBuilder: StorySettingsBuilder()
        )
        let view = StoryDetailView(presenter: presenter)
        presenter.view = view
        return view
    }
}
