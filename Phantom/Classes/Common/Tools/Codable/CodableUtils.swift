//
//  CodableUtils.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

public extension Decodable {
    static func decode(_ jsonData: Data, dateFormat: String = Date.defaultFormat) throws -> Self {
        let jsonDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        return try jsonDecoder.decode(Self.self, from: jsonData)
    }
}
