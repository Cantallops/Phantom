//
//  Searcheable.swift
//  Phantom
//
//  Created by Alberto Cantallops on 25/04/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

protocol Searcheable {
    func searchTerms() -> [String]
}

extension Array where Element: Searcheable {
    func search(text: String) -> [Element] {
        if text.isEmpty {
            return self
        }
        return self.filter { element -> Bool in
            return element.searchTerms().contains(where: { term -> Bool in
                return term.lowercased().contains(text.lowercased())
            })
        }
    }
}
