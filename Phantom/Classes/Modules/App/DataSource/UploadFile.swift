//
//  UploadFile.swift
//  Phantom
//
//  Created by Alberto Cantallops on 14/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct UploadProvider: NetworkProvider {
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

class UploadFile: DataSource<File, String> {

    override func execute(args: File) -> Result<String> {
        let provider = UploadProvider(file: args)
        let result: Result<Data> = Network(provider: provider).call()
        switch result {
        case .success(let data):
            let error = NetworkError(kind: .parse, debugDescription: "No image's URI found")
            guard let escapedUri = String(data: data, encoding: .utf8) else {
                return .failure(error)
            }
            let uri = escapedUri.replacing("\"", "")
            if URL(string: uri) == nil {
                return .failure(error)
            }
            return .success(uri)
        case .failure(let error):
            return .failure(error)
        }
    }
}
