//
//  SignUpVC.swift
//  CampusExplore
//
//  Created by Charan on 19/11/23.
//


import UIKit

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
            return false
        }
        
        if !email.text!.emailIsCorrect() {
            showAlerOnTop(message: "Please enter valid email id")
            return false
        }
        
        if(self.name.text!.isEmpty) {
            showAlerOnTop(message: "Please enter full name.")
            return false
        }
    
        if(self.password.text!.isEmpty) {
            showAlerOnTop(message: "Please enter password.")
            return false
        }
        
        return true
    }
}



