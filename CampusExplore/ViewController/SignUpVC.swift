//
//  SignUpVC.swift
//  CampusExplore
//
//  Created by Charan on 19/11/23.
//


import UIKit
import AVKit

class SignUpVC: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        if validate(){
            FireStoreManager.shared.signUp(email: self.email.text ?? "", name: self.name.text ?? "", password: self.password.text ?? "")
        }
        
    }

    @IBAction func onLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validate() ->Bool {
        
        if(self.email.text!.isEmpty) {
            showAlerOnTop(message: "Please enter email.")
            AudioServicesPlaySystemSound(1053)
            return false
        }
        
        if !email.text!.emailIsCorrect() {
            showAlerOnTop(message: "Please enter valid email id")
            AudioServicesPlaySystemSound(1053)
            return false
        }
        
        if(self.name.text!.isEmpty) {
            showAlerOnTop(message: "Please enter full name.")
            AudioServicesPlaySystemSound(1053)
            return false
        }
    
        if(self.password.text!.isEmpty) {
            showAlerOnTop(message: "Please enter password.")
            AudioServicesPlaySystemSound(1053)
            return false
        }
        
        return true
    }
}



