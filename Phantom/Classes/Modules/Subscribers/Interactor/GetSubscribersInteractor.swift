//
//  GetSubscribersInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetSubscribersInteractor: Interactor<Meta?, Paginated<[Subscriber]>> {

    let getSubscribersDataSource: DataSource<Meta?, Paginated<[Subscriber]>>

    init(
        getSubscribersDataSource: DataSource<Meta?, Paginated<[Subscriber]>> = GetSubscribersRemote()
    ) {
        self.getSubscribersDataSource = getSubscribersDataSource
        super.init()
    }

    override func execute(args: Meta?) -> Result<Paginated<[Subscriber]>> {
        return getSubscribersDataSource.execute(args: args)
    }
}
