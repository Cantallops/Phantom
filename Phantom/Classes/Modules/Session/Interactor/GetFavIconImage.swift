//
//  GetFavIconImage.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class GetFavIconImage: Interactor<Any?, UIImage> {
    override func execute(args: Any?) -> Result<UIImage> {
        guard let account = Account.current,
            let url = URL(string: "\(account.blogUrl)favicon.png")else {
            return .failure(NetworkError(kind: .unknown))
        }
        switch Network.Image.get(fromURL: url) {
        case .success(let image):
            if let image = image {
                return .success(image)
            }
            return .failure(NetworkError(kind: .unknown))
        case .failure(let error):
            return .failure(error)
        }
    }
}
