//
//  LoginVC.swift
//  CampusExplore
//
//  Created by Vishnu on 19/11/23.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import AVKit


class LoginVC: UITableViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLogin(_ sender: Any) {
    
        
            if(email.text!.isEmpty) {
                showAlerOnTop(message: "Please enter your email.")
                AudioServicesPlaySystemSound(1053)
                return
            }

            if(self.password.text!.isEmpty) {
                showAlerOnTop(message: "Please enter your password.")
                AudioServicesPlaySystemSound(1053)
                return
            }
        
        
            if(email.text == "admin@nwmissouri.edu" && password.text == "admin123") {
               
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdminHomeVC")
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }else {
                
                FireStoreManager.shared.login(email: email.text?.lowercased() ?? "", password: password.text ?? "") { success in
                    if success{
                            SceneDelegate.shared?.loginCheckOrRestart()
                    }
                    
                }
            }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "SignUpTableVC" ) as! SignUpTableVC
                
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

