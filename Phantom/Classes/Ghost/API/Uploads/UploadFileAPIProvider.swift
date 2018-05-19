//
//  UploadFileProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct UploadFileAPIProvider: NetworkProvider {
    let file: File

    var method: HTTPMethod {
        return .POST
    }
    var uri: String {
        return "/uploads/"
    }
    var authenticated: Bool {
        return true
    }
    var contentType: ContentType {
        return .multipart
    }
    var fileToUpload: File? {
        return file
    }
}
