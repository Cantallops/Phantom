//
//  StringUtils.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

public extension String {
    func replacing(_ toReplace: String, _ replace: String) -> String {
        return self.replacingOccurrences(of: toReplace, with: replace)
    }
}

public extension String {
    func trunc(length: Int, trailing: String = "…") -> String {
        if count <= length {
            return self
        }
        return prefix(length) + trailing
    }
}

public extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        return ceil(boundingBox.height)
    }
}
