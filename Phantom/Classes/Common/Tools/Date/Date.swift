//
//  Date.swift
//  Phantom
//
//  Created by Alberto Cantallops on 14/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
import SwiftDate

public extension Date {

    public static let defaultFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

    func colloquial(since: Date = Date()) -> String? {
        let colloquialTime: (String, String?)? = try? inGMTRegion().colloquial(toDate: since.inGMTRegion())
        return colloquialTime?.0
    }

    func formated(format: String = "dd/MM/yyyy mm:ss") -> String {
        return inGMTRegion().string(custom: format)
    }

    func apiFormated() -> String {
        return inGMTRegion().string(custom: Date.defaultFormat)
    }
}

public extension Date {
    func daysPassed(date: Date) -> Int {
        let diff = timeIntervalSince1970 - date.timeIntervalSince1970
        return Int(diff/60/60/24)
    }
}
