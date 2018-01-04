//
//  GetTagList.swift
//  Phantom
//
//  Created by Alberto Cantallops on 28/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetTagList: Interactor<Meta?, Paginated<[Tag]>> {

    let getTagListDataSource: DataSource<Meta?, Paginated<[Tag]>>

    init(getTagListDataSource: DataSource<Meta?, Paginated<[Tag]>> = GetTagListRemote()) {
        self.getTagListDataSource = getTagListDataSource
        super.init()
    }

    override func execute(args: Meta?) -> Result<Paginated<[Tag]>> {
        return getTagListDataSource.execute(args: args)
    }
}
