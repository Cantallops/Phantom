//
//  GetMe.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetMe: Interactor<Any?, TeamMember> {

    private let getMeRemote: DataSource<Any?, TeamMember>

    init(
        getMeRemote: DataSource<Any?, TeamMember> = GetMeRemote()
    ) {
        self.getMeRemote = getMeRemote
        super.init()
    }

    override func execute(args: Any?) -> Result<TeamMember> {
        return getMeRemote.execute(args: args)
    }
}
