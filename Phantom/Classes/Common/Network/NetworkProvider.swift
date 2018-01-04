//
//  NetworkProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct File {
    let mimeType: String
    let data: Data
    let path: String
    let name: String
}

protocol NetworkProvider {
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: JSON { get }
    var queryParameters: JSON { get }
    var baseUrl: String { get }
    var versioning: String? { get }
    var uri: String { get }
    var authenticated: Bool { get }
    var useClientKeys: Bool { get }
    var contentType: ContentType { get }
    var fileToUpload: File? { get }
}

extension NetworkProvider {
    var baseUrl: String {
        return Account.current?.blogUrl ?? ""
    }

    var versioning: String? {
        return Account.current?.apiVersion ?? ""
    }

    var headers: [String: String]? {
        return nil
    }

    var parameters: JSON {
        return [:]
    }

    var queryParameters: JSON {
        return [:]
    }

    var authenticated: Bool {
        return false
    }

    var useClientKeys: Bool {
        return false
    }

    var contentType: ContentType {
        return .formURLEncoded
    }

    var fileToUpload: File? {
        return nil
    }

}
