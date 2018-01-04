//
//  GetMembers.swift
//  Phantom
//
//  Created by Alberto Cantallops on 18/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetMembers: Interactor<Meta?, Paginated<[TeamMember]>> {

    private let getMembersRemote: DataSource<Meta?, Paginated<[TeamMember]>>

    init(
        getMembersRemote: DataSource<Meta?, Paginated<[TeamMember]>> = GetTeamRemote()
    ) {
        self.getMembersRemote = getMembersRemote
        super.init()
    }

    override func execute(args: Meta?) -> Result<Paginated<[TeamMember]>> {
        return getMembersRemote.execute(args: args)
    }
}
