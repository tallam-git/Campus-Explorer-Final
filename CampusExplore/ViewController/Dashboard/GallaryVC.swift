//
//  GallaryVC.swift
//  CampusExplore
//
//  Created by Poojitha on 21/11/23.
//

import UIKit
import MobileCoreServices

class GallaryVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBAction func onUpload(_ sender: Any) {
        
        self.pickImageFromGallery()
    }
    
  
}


extension GallaryVC {
    
    func pickImageFromGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String] // Allow only images, not videos

        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.showLoadingIndicator()
                if let imageData = pickedImage.jpegData(compressionQuality: 0.5) {
                    // Now you have the image data, you can use it as needed
                    FireStoreManager.shared.uploadImageToStorage(imageData: imageData) { (url) in
                        self.hideLoadingIndicator()
                        firstTimeNot = true
                        if let imageUrl = url {
                            // Image uploaded successfully, save the URL to Firestore
                            FireStoreManager.shared.saveImageURLToFirestore(url: imageUrl)
                        } else {
                            // Handle error
                            print("Error uploading image or getting URL.")
                        }
                    }
                } else {
                    self.hideLoadingIndicator()
                    // Handle error converting image to data
                    print("Error converting image to data.")
                }
            }
        } else {
            // Handle error picking image
            print("Error picking image.")
            dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func showLoadingIndicator() {
           // Implement code to show loading indicator, e.g., using UIActivityIndicatorView
           let activityIndicator = UIActivityIndicatorView(style: .large)
           activityIndicator.center = view.center
           activityIndicator.startAnimating()
           activityIndicator.color = .red
           activityIndicator.backgroundColor = UIColor.white
           view.addSubview(activityIndicator)
       }

       func hideLoadingIndicator() {
           // Implement code to hide loading indicator
           // Remove or hide the previously added UIActivityIndicatorView
           for subview in view.subviews {
               if let activityIndicator = subview as? UIActivityIndicatorView {
                   activityIndicator.stopAnimating()
                   activityIndicator.removeFromSuperview()
               }
           }
       }
    
}
