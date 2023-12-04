//
//  AddInfoVC.swift
//  CampusExplore
//
//  Created by Charan on 01/12/23.
//

import UIKit

struct Photo {
    var image: UIImage
    var downloadURL: URL?
}

class AddInfoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var subjectView: DesignableView!
    @IBOutlet weak var imageView: UIImageView!
    var moveFrom = ""
    let imagePicker = UIImagePickerController()
    var photos: [Photo] = []
  
    
    override func viewDidLoad() {
         
        if(self.moveFrom == "Building") {
            self.subjectView.isHidden  = true
        }
    }
    
    @IBAction func selectPhotos(_ sender: UIButton) {
        showImagePicker()
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let photo = Photo(image: image)
            photos.removeAll()
            photos.append(photo)
            self.imageView.image = photo.image
        }
    }
    
   
    @IBAction func onUpload(_ sender: Any) {
        
        
        if(name.text!.isEmpty) {
            showAlerOnTop(message: "Please enter name.")
            return
        }
        
        if(textDescription.text!.isEmpty || textDescription.text! == "Description") {
            showAlerOnTop(message: "Please add description.")
            return
        }
        
        if(photos.isEmpty) {
            showAlerOnTop(message: "Please add photo.")
            return
        }
        
        if(self.moveFrom == "Professor") {
            
            if(self.subject.text!.isEmpty) {
                showAlerOnTop(message: "Please add subject.")
                return
            }
            
        }
        
        self.uploadImagesIntoFireStore()
    }
    
    func uploadImagesIntoFireStore() {
        
        FireStoreManager.shared.uploadAndGetDataURLs(photos) { (updatedPhotos, downloadURLs, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Download URLs: \(downloadURLs)")
                
                if(self.moveFrom == "Building") {
                    
                    FireStoreManager.shared.storeBuildingDataInFirestore(urls: downloadURLs, detail: self.textDescription.text!, name: self.name.text!) { success in
                            if success {
                                        self.navigationController?.popViewController(animated: true)
                            }
                    }
                    
                }else {
                    
                    FireStoreManager.shared.storeFacultyDataInFirestore(urls: downloadURLs, detail: self.textDescription.text!, name: self.name.text!, sub : self.subject.text!) { success in
                            if success {
                                        self.navigationController?.popViewController(animated: true)
                            }
                    }
                    
                }
               
            }
        }
    }
}
 
