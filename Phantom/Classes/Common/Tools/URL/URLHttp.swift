//
//  URLHttp.swift
//  Phantom
//
//  Created by Alberto Cantallops on 20/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

extension URL {
    var absoluteStringWithHttp: String {
        if absoluteString.hasPrefix("https://") || absoluteString.hasPrefix("http://") {
            return absoluteString
        }
        return "http://\(absoluteString)"
    }
}
