//
//  ProfileVC.swift
//  CampusExplore
//
//  Created by Charan on 23/11/23.
//

import UIKit

 
class ProfileVC: UIViewController {

   
   @IBOutlet weak var firstName: UITextField!
  
   @IBOutlet weak var email: UITextField!
 
   override func viewWillAppear(_ animated: Bool) {
       firstName.text = UserDefaultsManager.shared.getName()
       email.text = UserDefaultsManager.shared.getEmail()
   }
   
   
   @IBAction func onLogotClicked(_ sender: Any) {
       
       showConfirmationAlert(message: "Are you sure want to logout?") { _ in
           
           UserDefaultsManager.shared.clearData()
           
           SceneDelegate.shared?.loginCheckOrRestart()
       }
      
   }
    
    @IBAction func onUpdatePasswordClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "UpdatePasswordVC" ) as! UpdatePasswordVC
                
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
