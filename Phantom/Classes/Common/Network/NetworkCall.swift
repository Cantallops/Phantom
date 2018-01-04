//
//  NetworkCall.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

extension Network {
    func call<T: Codable>(tryRefreshOauth: Bool = true) -> Result<T> {
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<T> = .failure(NetworkError(kind: .unknown))
        networkIndicator(activate: true)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            result = self.process(data: data, response: response, error: error)
            semaphore.signal()
        }
        dataTask.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        if tryRefreshOauth && Network.isUnauthorized(result: result),
            var account = Account.current {
            if let oauth = account.oauth {
                let refreshResult = refreshOauth.execute(args: oauth)
                switch refreshResult {
                case .success(let oauth):
                    account.oauth = oauth
                    Account.current = account
                    return call(tryRefreshOauth: false)
                case .failure:
                    return result
                }
            }
        }

        networkIndicator(activate: false)
        return result
    }

    func process<T: Codable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T> {
        let networkResponse = Response(data: data, response: response, error: error)
        if let networkError = NetworkError(response: networkResponse) {
            return .failure(networkError)
        }
        if let data = data {
            if let data = data as? T {
                return .success(data)
            }
            do {
                let object = try T.decode(data)
                return .success(object)
            } catch let error {
                return .failure(NetworkError(kind: .parse, response: networkResponse, error: error))
            }
        }

        return .failure(NetworkError(kind: .unknown, response: networkResponse))
    }

}

extension Network {
    static func isUnauthorized<T>(result: Result<T>) -> Bool {
        switch result {
        case .success: return false
        case .failure(let error):
            if let error = error as? NetworkError {
                return error.kind == .unauthorized
            }
            return false
        }
    }
}

public func networkIndicator(activate: Bool) {
    DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = activate
    }
}
