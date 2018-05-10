//
//  GetStoriesListInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetStoriesListInteractor: Interactor<Meta?, Paginated<[Story]>> {

    let getStoriesListDataSource: DataSource<Meta?, Paginated<[Story]>>

    init(
        getStoriesListDataSource: DataSource<Meta?, Paginated<[Story]>> = GetStoriesListRemote()
    ) {
        self.getStoriesListDataSource = getStoriesListDataSource
        super.init()
    }

    override func execute(args: Meta?) -> Result<Paginated<[Story]>> {
        return getStoriesListDataSource.execute(args: args)
    }
}
