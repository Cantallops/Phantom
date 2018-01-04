//
//  Meta.swift
//  Phantom
//
//  Created by Alberto Cantallops on 28/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct Meta: Codable {
    struct Pagination: Codable {
        let page: Int
        let limit: String
        let pages: Int
        let total: Int
        let next: Int?
        let prev: Int?
    }

    let pagination: Pagination
}

extension Meta.Pagination {
    static let all = Meta.Pagination(page: 0, limit: "all", pages: 0, total: 0, next: nil, prev: nil)
    var isFirst: Bool {
        return page == 0
    }
}

struct Paginated<T: Codable>: Codable {
    let object: T
    let meta: Meta
}
