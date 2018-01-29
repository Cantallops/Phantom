//
//  Network.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

enum HTTPMethod: String {
    case POST
    case GET
    case PUT
    case DELETE
}

enum ContentType: String {
    case formURLEncoded = "application/x-www-form-urlencoded"
    case json = "application/json"
    case multipart = "multipart/form-data"
}

class Network: NSObject {

    var refreshOauth: DataSource<Oauth, Oauth>

    var provider: NetworkProvider
    var authenticated: Bool {
        return provider.authenticated
    }

    init(
        provider: NetworkProvider,
        refreshOauth: DataSource<Oauth, Oauth> = RefreshOauth()
    ) {
        self.provider = provider
        self.refreshOauth = refreshOauth
        super.init()
    }

    var urlRequest: URLRequest {
        let method = provider.method
        var parameters = provider.parameters
        if provider.useClientKeys {
            parameters = authenticate(parameters: parameters)
        }
        let url: URL = build()
        var urlRequest = URLRequest(url: url)
        var headers = provider.headers ?? [:]
        headers["Content-Type"] = provider.contentType.rawValue
        if provider.authenticated {
            urlRequest.allHTTPHeaderFields = authenticate(header: urlRequest.allHTTPHeaderFields)
        }
        urlRequest.httpMethod = method.rawValue

        let encodeParams = parameters.encode()

        switch method {
        case .POST, .PUT, .DELETE:
            switch provider.contentType {
            case .formURLEncoded:
                urlRequest.httpBody = encodeParams.data(using: .utf8)
            case .json:
                let data = try? JSONSerialization.data(withJSONObject: parameters)
                let json = String(data: data!, encoding: .utf8)!
                urlRequest.httpBody = json.data(using: .utf8)
            case .multipart:
                if let file = provider.fileToUpload {
                    let boundary = generateBoundaryString()
                    headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
                    urlRequest.httpBody = createRequestBodyWith(
                        parameters: provider.parameters,
                        file: file,
                        boundary: boundary
                    )
                }
            }

        case .GET where !encodeParams.isEmpty:
            urlRequest.url = URL(string: "\(url.absoluteString)?\(encodeParams)")!
        case .GET: // It has no encode parameters
            break
        }

        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }

    internal func build() -> URL {
        var url = URL(string: provider.baseUrl)!
        if let versioning = provider.versioning {
            url = url.appendingPathComponent(versioning)
        }
        url = url.appendingPathComponent(provider.uri)
        if provider.queryParameters.count > 0 {
            url = URL(string: "\(url.absoluteString)?\(provider.queryParameters.encode())")!
        }
        return url
    }

    internal func authenticate(parameters: JSON) -> JSON {
        var authenticatedParameters = parameters
        authenticatedParameters["client_id"] = Account.current?.clientKeys?.id
        authenticatedParameters["client_secret"] = Account.current?.clientKeys?.secret
        return authenticatedParameters
    }

    internal func authenticate(header: [String: String]?) -> [String: String] {
        var authenticatedHeader = header ?? [:]
        authenticatedHeader["Authorization"] = Account.current?.oauth?.authorization
        return authenticatedHeader
    }
}

private extension Dictionary where Key == String {
    func encode() -> String {
        var parameterArray: [String] = []
        for (key, value) in self {
            if let percentEscapedKey = key.addingPercentEncodingForURLQueryValue(),
                let percentEscapedValue = "\(value)".addingPercentEncodingForURLQueryValue() {
                parameterArray.append("\(percentEscapedKey)=\(percentEscapedValue)")
            }
        }
        return parameterArray.joined(separator: "&")
    }
}

private extension String {
    func addingPercentEncodingForURLQueryValue() -> String? {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return addingPercentEncoding(withAllowedCharacters: allowed)
    }
}

fileprivate extension Data {
    mutating func append(string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}

private extension Network {
    func createRequestBodyWith(
        parameters: JSON,
        file: File,
        boundary: String
    ) -> Data {
        var body = Data()
        for (key, value) in parameters {
            body.append(string: "--\(boundary)\r\n")
            body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append(string: "\(value)\r\n")
        }
        body.append(string: "--\(boundary)\r\n")
        body.append(string: "Content-Disposition: form-data; name=\"uploadimage\"; filename=\"\(file.name)\"\r\n")
        body.append(string: "Content-Type: \(file.mimeType)\r\n\r\n")
        body.append(file.data)
        body.append(string: "\r\n")
        body.append(string: "--\(boundary)--\r\n")

        return body
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
