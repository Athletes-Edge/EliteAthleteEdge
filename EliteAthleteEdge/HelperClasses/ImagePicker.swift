//
//  ImagePicker.swift
//  SocialMedia
//
//  Created by Mac on 12/05/2023.
//

import UIKit
import MobileCoreServices
import AVFoundation

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
    func didSelectVedio(vedioUrl: URL?, thumbnail: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        setMediaTypeImage()
    }
   
    private func setMediaTypeImage() {
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    private func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Camera") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func generateThumbnail(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: videoURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            var thumbnail: UIImage?
            
            do {
                let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                thumbnail = UIImage(cgImage: cgImage)
            } catch {
                print("Error generating thumbnail: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(thumbnail)
            }
        }
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        if let image = image {
            self.delegate?.didSelect(image: image)
        }
    }
    
    public func presentForVedio(from sourceView: UIView) {
        self.pickerController.mediaTypes = [kUTTypeMovie as String]
         present(from: sourceView)
    }
    
    public func presentForCamera(from sourceView: UIView) {
        setMediaTypeImage()
        present(from: sourceView)
    }

    public func pickImageFromCamera() {
        setMediaTypeImage()
        self.pickerController.sourceType = UIImagePickerController.SourceType.camera
        self.presentationController?.present(self.pickerController, animated: true)
    }
    
    public func pickImageFromPhotoLibrary() {
        setMediaTypeImage()
        self.pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.presentationController?.present(self.pickerController, animated: true)
    }
}
extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let videoURL = info[.mediaURL] as? URL {
            generateThumbnail(from: videoURL) { [weak self]image in
                guard let self = self else { return }
                self.pickerController(picker, didSelect: nil)
                self.delegate?.didSelectVedio(vedioUrl: videoURL, thumbnail: image)
            }
            return
        }
        
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}
extension ImagePicker: UINavigationControllerDelegate {

}
