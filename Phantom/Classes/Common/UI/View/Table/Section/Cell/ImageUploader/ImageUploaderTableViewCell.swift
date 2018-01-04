//
//  ImageUploaderTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 15/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class ImageUploaderTableViewCell: TableViewCell {

    @IBOutlet weak var imageUploaderView: ImageUploaderView!

    class Conf: TableCellConf {
        var urlString: String?
        var onUploadImage: OnUploadImage?
        var onRemoveImage: OnRemoveImage?
        weak var viewToPresent: UIViewController!

        init(
            urlString: String? = nil,
            onUploadImage: OnUploadImage? = nil,
            onRemoveImage: OnRemoveImage? = nil,
            viewToPresent: UIViewController
        ) {
            self.urlString = urlString
            self.onUploadImage = onUploadImage
            self.onRemoveImage = onRemoveImage
            self.viewToPresent = viewToPresent
            super.init(
                identifier: "ImageUploaderCell",
                nib: UINib(nibName: "ImageUploaderTableViewCell", bundle: nil)
            )
            self.height = 250
            self.estimatedHeight = 250
            self.canSelect = false
            self.showSelection = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageUploaderView.layer.cornerRadius = 4
        imageUploaderView.clipsToBounds = true
        imageUploaderView.layer.masksToBounds = true
        imageUploaderView.layer.borderWidth = 1.0
        imageUploaderView.layer.borderColor = Color.border.cgColor
    }

    override func configure(with configuration: TableCellConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? Conf else {
            // Add a warning
            return
        }
        let url = URL(string: conf.urlString ?? "")
        imageUploaderView.configurate(
            withUrl: url,
            onUploadImage: conf.onUploadImage,
            onRemoveImage: conf.onRemoveImage,
            viewToPresent: conf.viewToPresent
        )
    }

}
