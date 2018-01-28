//
//  NetworkError.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

extension Network {
    struct Response {
        let data: Data?
        let response: URLResponse?
        let error: Error?

        var statusCode: Int? {
            if let response = response,
                let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode
            }
            return nil
        }
    }
}

struct NetworkError: Error {
    var kind: Kind
    var localizedDescription: String?
    var debugDescription: String?
    var response: Network.Response?
    var error: Error?

    enum Kind: String {
        case unknown
        case unauthorized = "UnauthorizedError"
        case validation = "ValidationError"
        case tooManyRequests = "TooManyRequestsError"
        case multiple
        case parse
    }

    init(
        kind: Kind,
        localizedDescription: String? = nil,
        debugDescription: String? = nil,
        response: Network.Response? = nil,
        error: Error? = nil
    ) {
        self.kind = kind
        self.localizedDescription = localizedDescription
        self.response = response
        self.error = error
        self.debugDescription = debugDescription ?? localizedDescription
    }

    init?(response: Network.Response) {
        self.response = response
        if let error = response.error {
            kind = .unknown
            localizedDescription = error.localizedDescription
            debugDescription = localizedDescription
            return
        } else if let data = response.data, let errors = try? GhostErrors.decode(data) {
            kind = errors.networkError
            localizedDescription = errors.message
            debugDescription = localizedDescription
            return
        }
        switch response.statusCode {
        case 401?:
            kind = .unauthorized
            localizedDescription = "Access denied"
            debugDescription = localizedDescription
            return
        default:
            return nil
        }
    }
}

extension Error {
    var isUnauthoriezed: Bool {
        if let error = self as? NetworkError {
            return error.kind == .unauthorized
        }
        if let error = self as? CombinedError {
            return error.errors.contains(where: {
                return ($0 as? NetworkError)?.kind == .unauthorized
            })
        }
        return false
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        return self.localizedDescription
    }
}

struct GhostErrors: Codable {
    let errors: [GhostError]

    var message: String {
        return errors.flatMap({ return $0.message }).joined(separator: "\n")
    }
    var networkError: NetworkError.Kind {
        let networkErrors = errors.flatMap({ return $0.networkErrorKind })
        switch networkErrors.count {
        case 0:
            return .unknown
        case 1:
            return networkErrors.first!
        default:
            return .multiple
        }
    }
}

struct GhostError: Codable {
    let message: String?
    let context: String?
    let errorType: String?

    var networkErrorKind: NetworkError.Kind {
        if let errorType = errorType, let kind = NetworkError.Kind(rawValue: errorType) {
            return kind
        }
        return .unknown
    }
}
