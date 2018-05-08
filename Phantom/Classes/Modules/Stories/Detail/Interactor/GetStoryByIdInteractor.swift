//
//  GetStoryByIdInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 08/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetStoryByIdInteractor: Interactor<String, Story> {

    let getStoryByIdDataSource: DataSource<String, Story>

    init(
        getStoryByIdDataSource: DataSource<String, Story> = GetStoryRemote()
    ) {
        self.getStoryByIdDataSource = getStoryByIdDataSource
        super.init()
    }

    override func execute(args: String) -> Result<Story> {
        return getStoryByIdDataSource.execute(args: args)
    }
}
