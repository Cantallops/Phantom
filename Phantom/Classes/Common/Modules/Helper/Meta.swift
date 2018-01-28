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
        enum Limit {
            case all
            case number(Int)

            var string: String {
                switch self {
                case .all:
                    return "all"
                case .number(let number):
                    return "\(number)"
                }
            }
        }

        let page: Int
        let limit: String
        let pages: Int
        let total: Int
        let next: Int?
        let prev: Int?

        init(page: Int, limit: Limit, pages: Int = 0, total: Int = 0, next: Int? = nil, prev: Int? = nil) {
            self.page = page
            self.limit = limit.string
            self.pages = pages
            self.total = total
            self.next = next
            self.prev = prev
        }
    }

    let pagination: Pagination
}

extension Meta.Pagination {
    static let all = Meta.Pagination(page: 0, limit: .all)
    var isFirst: Bool {
        return page == 0
    }
}

struct Paginated<T: Codable>: Codable {
    let object: T
    let meta: Meta
}
