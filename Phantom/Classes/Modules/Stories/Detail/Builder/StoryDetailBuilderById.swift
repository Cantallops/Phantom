//
//  StoryDetailBuilderById.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

class StoryDetailBuilderById: Builder<String, ViewController> {
    override func build(arg: String) -> ViewController {
        let presenter = StoryDetailByIdPresenter(
            id: arg,
            getStoryById: GetStoryByIdInteractor(),
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
