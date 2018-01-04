//
//  NetworkImage.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

extension Network {
    struct Image {
        static func get(fromURL url: URL) -> Result<UIImage?> {
            networkIndicator(activate: true)
            let semaphore = DispatchSemaphore(value: 0)
            var result: Result<UIImage?> = .failure(NetworkError(kind: .unknown))
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                result = Network.Image.process(data: data, response: response, error: error)
                semaphore.signal()
            }
            dataTask.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)

            networkIndicator(activate: false)
            return result
        }

        private static func process(data: Data?, response: URLResponse?, error: Error?) -> Result<UIImage?> {
            let networkResponse = Response(data: data, response: response, error: error)
            if let networkError = NetworkError(response: networkResponse) {
                return .failure(networkError)
            }
            if let response = response as? HTTPURLResponse, !(200 ... 299).contains(response.statusCode) {
                return .failure(NetworkError(kind: .unknown, response: networkResponse))
            }

            let semaphore = DispatchSemaphore(value: 0)
            if let data = data {
                var image: UIImage?
                DispatchQueue.main.async {
                    image = UIImage(data: data)
                    semaphore.signal()
                }
                _ = semaphore.wait(timeout: DispatchTime.distantFuture)
                return .success(image)
            }

            return .failure(NetworkError(kind: .unknown, response: networkResponse))
        }
    }
}
