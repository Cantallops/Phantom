//
//  GetCurrentBlogInfoInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

struct BlogInfo {
    let blogConf: BlogConfiguration
    let favicon: UIImage?
    let user: TeamMember
}

class GetCurrentBlogInfoInteractor: Interactor<Any?, BlogInfo> {

    private let getBlogConfiguration: DataSource<(String, String), BlogConfiguration>
    private let getMe: Interactor<Any?, TeamMember>
    private let getFavIconImage: Interactor<Any?, UIImage>

    init(
        getBlogConfiguration: DataSource<(String, String), BlogConfiguration> = GetBlogConfiguration(),
        getMe: Interactor<Any?, TeamMember> = GetMeInteractor(),
        getFavIconImage: Interactor<Any?, UIImage> = GetFavIconImageInteractor()
    ) {
        self.getBlogConfiguration = getBlogConfiguration
        self.getMe = getMe
        self.getFavIconImage = getFavIconImage
        super.init()
    }

    override func execute(args: Any?) -> Result<BlogInfo> {
        guard let account = Account.current else {
            return .failure(NetworkError(kind: .unknown))
        }
        let blogConfResult = getBlogConfiguration.execute(args: (account.blogUrl, account.apiVersion))
        let meResult = getMe.execute(args: nil)
        let favIconResult = getFavIconImage.execute(args: nil)
        let blogMeResult = blogConfResult.combined(result: meResult)
        switch blogMeResult {
        case .success(let blogConf, let me):
            return .success(BlogInfo(blogConf: blogConf, favicon: favIconResult.value, user: me))
        case .failure(let error):
            return .failure(error)
        }
    }
}
