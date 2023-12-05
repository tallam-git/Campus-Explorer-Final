//
//  FullImageVC.swift
//  CampusExplore
//
//  Created by Charan on 10/11/23.
//

import UIKit
import AVKit

class FullImageVC: UIViewController {

    var imageUrl = ""
    
    @IBOutlet weak var imageView: UIImageView!
    
    
//    override func viewDidLoad() {
//        
//        self.imageView.sd_setImage(with: imageUrl.encodedURL().toURL(), placeholderImage: UIImage(named: ""))
//    }
    
    override func viewDidLoad() {
                super.viewDidLoad()

                // Set up initial state
                imageView.alpha = 0.0
                imageView.transform = CGAffineTransform(rotationAngle: .pi / 2) // Rotate 90 degrees

                // Load the image with a fade-in and rotate animation
                UIView.animate(withDuration: 0.5, animations: {
                    self.imageView.sd_setImage(with: self.imageUrl.encodedURL().toURL(), placeholderImage: UIImage(named: ""))
                    self.imageView.alpha = 1.0
                    self.imageView.transform = .identity // Reset rotation to 0 degrees
                })
            }
    
    @IBAction func onDeleteImage(_ sender: Any) {
        FireStoreManager.shared.deleteImageUrlFromFirestore(imageUrlToDelete: imageUrl) { success in
            if success{
                showAlerOnTop(message: "Deleted successfully")
                AudioServicesPlaySystemSound(1112)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
