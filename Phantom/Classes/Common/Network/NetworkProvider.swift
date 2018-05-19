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

extension NetworkProvider {
    var urlRequest: URLRequest {
        var params = parameters
        if useClientKeys {
            params = authenticate(parameters: params)
        }
        let url: URL = build()
        var urlRequest = URLRequest(url: url)
        var headers = self.headers ?? [:]
        headers["Content-Type"] = contentType.rawValue
        if authenticated {
            urlRequest.allHTTPHeaderFields = authenticate(header: urlRequest.allHTTPHeaderFields)
        }
        urlRequest.httpMethod = method.rawValue

        let encodeParams = params.encode()

        switch method {
        case .POST, .PUT, .DELETE:
            switch contentType {
            case .formURLEncoded:
                urlRequest.httpBody = encodeParams.data(using: .utf8)
            case .json:
                let data = try? JSONSerialization.data(withJSONObject: parameters)
                let json = String(data: data!, encoding: .utf8)!
                urlRequest.httpBody = json.data(using: .utf8)
            case .multipart:
                if let file = fileToUpload {
                    let boundary = generateBoundaryString()
                    headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
                    urlRequest.httpBody = createRequestBodyWith(
                        parameters: parameters,
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
        var url = URL(string: baseUrl)!
        if let versioning = versioning {
            url = url.appendingPathComponent(versioning)
        }
        url = url.appendingPathComponent(uri)
        if queryParameters.count > 0 {
            url = URL(string: "\(url.absoluteString)?\(queryParameters.encode())")!
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

extension NetworkProvider {
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

fileprivate extension Data {
    mutating func append(string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
