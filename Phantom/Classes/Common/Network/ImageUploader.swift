//
//  ImageUploader.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

extension ImageUploader: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        uploadImage(withInfo: info)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        loaders?.stop()
        picker.dismiss(animated: true)
        onCancel?()
    }
}

extension ImageUploader: UINavigationControllerDelegate {

}

class ImageUploader: NSObject {

    typealias ImageResult = (Result<String>, UIImage?)
    typealias OnResult = (ImageResult) -> Void
    typealias OnCancel = () -> Void

    private var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()

        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }()

    private var loaders: [Loader]?
    private var uploader: DataSource<File, String> = UploadFile()
    private var onResult: OnResult!
    private var onCancel: OnCancel?

    convenience init(
        loaders: [Loader]? = nil,
        onResult: @escaping OnResult,
        onCancel: OnCancel? = nil
    ) {
        self.init()
        self.onResult = onResult
        self.loaders = loaders
        self.onCancel = onCancel
    }

    func show(`in` viewController: UIViewController) {
        loaders?.start()
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true)
    }

    private func uploadImage(
        withInfo info: [String: Any]
    ) {
        var imageURLKeyPath = UIImagePickerControllerMediaURL
        if #available(iOS 11.0, *) {
            imageURLKeyPath = UIImagePickerControllerImageURL
        }
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let url = info[imageURLKeyPath] as? URL else {
                onResult((.failure(NetworkError(kind: .unknown)), nil))
                return
        }
        var resized = chosenImage
        let maxWidthOrHeight: CGFloat = 300
        if resized.size.height > maxWidthOrHeight || resized.size.width > maxWidthOrHeight {
            resized = chosenImage.resize(withSize: CGSize(width: maxWidthOrHeight, height: maxWidthOrHeight))
        }
        guard let data = UIImageJPEGRepresentation(resized, 0.5) else {
                onResult((.failure(NetworkError(kind: .unknown)), nil))
                return
        }

        let file = File(
            mimeType: "image/\(url.pathExtension)",
            data: data,
            path: url.query ?? "/images",
            name: url.lastPathComponent
        )

        async(loaders: loaders, background: {
            return self.uploader.execute(args: file)
        }, main: { [weak self] result in
            self?.onResult((result, chosenImage))
        })
    }
}
