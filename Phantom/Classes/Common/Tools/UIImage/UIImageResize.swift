//
//  UIImageResize.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

public extension UIImage {
    func resize(withSize newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / self.size.width
        let verticalRatio = newSize.height / self.size.height

        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: newSize, format: renderFormat)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resizedImage
    }

    func rounded(withCornerRadius radius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let clippingPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: radius)
        clippingPath.addClip()

        draw(in: CGRect(origin: .zero, size: size))

        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return roundedImage
    }
}
