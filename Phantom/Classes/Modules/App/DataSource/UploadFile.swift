//
//  UploadFile.swift
//  Phantom
//
//  Created by Alberto Cantallops on 14/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class UploadFile: DataSource<File, String> {

    override func execute(args: File) -> Result<String> {
        let provider = UploadFileAPIProvider(file: args)
        let result: Result<Data> = Network().call(provider: provider)
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
