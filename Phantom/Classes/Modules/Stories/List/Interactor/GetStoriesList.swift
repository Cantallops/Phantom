//
//  GetStoriesList.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetStoriesList: Interactor<Meta?, Paginated<[Story]>> {

    let getStoriesListDataSource: DataSource<Meta?, Paginated<[Story]>>
    let indexStories: Interactor<[Story], Any?>

    init(
        getStoriesListDataSource: DataSource<Meta?, Paginated<[Story]>> = GetStoriesListRemote(),
        indexStories: Interactor<[Story], Any?> = IndexStories()
    ) {
        self.getStoriesListDataSource = getStoriesListDataSource
        self.indexStories = indexStories
        super.init()
    }

    override func execute(args: Meta?) -> Result<Paginated<[Story]>> {
        let result = getStoriesListDataSource.execute(args: args)
        if let stories = result.value?.object {
            _ = indexStories.execute(args: stories)
        }
        return result
    }
}
