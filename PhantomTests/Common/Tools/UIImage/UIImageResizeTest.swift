//
//  UIImageResizeTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 15/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest

class UIImageResizeTest: XCTestCase {
    func testResize() {
        let image = #imageLiteral(resourceName: "logo.png")
        let size = image.size
        let newSize = CGSize(width: size.width/2, height: size.height/2)
        let resizedImage = image.resize(withSize: newSize)
        XCTAssertEqual(resizedImage.size, newSize)
    }
}
