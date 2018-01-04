//
//  ImageUploaderView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 15/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import PopupDialog

struct UploadedImage {
    let url: URL
    let image: UIImage
}

typealias OnUploadImage = (String, UIImage) -> Void
typealias OnRemoveImage = () -> Void

class ImageUploaderView: UIView {
    private var view: UIView!

    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var uploadButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    private weak var viewToPresent: UIViewController!

    private var onUploadImage: OnUploadImage?
    private var onRemoveImage: OnRemoveImage?

    private var uploader: ImageUploader!

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    private func customInit() {
        setUpXib()
        uploader = ImageUploader(loaders: [activityIndicatorView], onResult: handleUpload) { [weak self] in
            self?.removedImage()
        }
        setUpRemoveButton()
        setUpUploadButton()
        setUpErrorLabel()
    }

    private func setUpRemoveButton() {
        removeButton.setImage(#imageLiteral(resourceName: "ic_image_remove").withRenderingMode(.alwaysOriginal), for: .normal)
    }

    private func setUpUploadButton() {
        uploadButton.layer.cornerRadius = 3
        uploadButton.layer.borderWidth = 1
        uploadButton.layer.borderColor = Color.border.cgColor
    }

    private func setUpErrorLabel() {
        errorLabel.textColor = Color.red
    }

    func configurate(
        withUrl url: URL? = nil,
        onUploadImage: OnUploadImage? = nil,
        onRemoveImage: OnRemoveImage? = nil,
        viewToPresent: UIViewController
    ) {
        self.onUploadImage = onUploadImage
        self.onRemoveImage = onRemoveImage
        self.viewToPresent = viewToPresent

        activityIndicatorView.stopAnimating()
        if let url = url {
            showImage(inUrl: url)
        } else {
            removedImage()
        }
    }

    @IBAction func tapUploadButton() {
        clear()
        uploader.show(in: viewToPresent)
    }

    @IBAction func tapRemoveButton() {
        onRemoveImage?()
        removedImage()
    }

    private func removedImage() {
        removeButton.isHidden = true
        uploadButton.isHidden = false
        imageView.image = nil
        removeError()
    }

    private func shownImage() {
        removeButton.isHidden = false
        uploadButton.isHidden = true
        removeError()
    }

    private func clear() {
        removeButton.isHidden = true
        uploadButton.isHidden = true
        removeError()
    }

    private func showImage(inUrl url: URL) {
        clear()
        async(loaders: [activityIndicatorView], background: {
            return Network.Image.get(fromURL: url)
        }, main: { [weak self] result in
            switch result {
            case .success(let image):
                self?.imageView.image = image
                self?.shownImage()
            case .failure(let error):
                self?.handle(error: error)
            }
        })
    }

    private func handleUpload(withResult onResult: (Result<String>, UIImage?)) {
        let (result, image) = onResult
        imageView.image = image
        switch result {
        case .success(let uri): upload(successfulImage: image!, withUri: uri)
        case .failure(let error): handle(error: error)
        }
    }

    private func upload(successfulImage image: UIImage, withUri uri: String) {
        shownImage()
        onUploadImage?(uri, image)
    }

    private func removeError() {
        errorLabel.isHidden = true
    }

    private func handle(error: Error) {
        removedImage()
        errorLabel.isHidden = false
        errorLabel.text = error.localizedDescription
    }

    private func setUpXib() {
        view = loadViewFromNib(name: "ImageUploaderView")
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
