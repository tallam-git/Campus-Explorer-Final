//
//  UpdatePasswordVC.swift
//  CampusExplore
//
//  Created by Vishnu on 10/11/23.
//


import UIKit

class UpdatePasswordVC: UIViewController {
    @IBOutlet weak var oldpassword: UITextField!
    @IBOutlet weak var newpassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!

    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FireStoreManager.shared.getPassword(email: UserDefaultsManager.shared.getEmail(), password: "") { getpassword in
            self.password = getpassword
        }
        
    }
    
    @IBAction func onChangePassword(_ sender: Any) {
        if validate(){
            if(self.oldpassword.text! != self.password) {
                showAlerOnTop(message: "Please enter correct current password")
                return
            }
            else {
                let documentid = UserDefaults.standard.string(forKey: "documentId") ?? ""
                let userdata = ["password": self.newpassword.text ?? ""]
                FireStoreManager.shared.updatePassword(documentid: documentid, userData: userdata) { success in
                    if success {
                        showAlerOnTop(message: "Password Updated Successfully")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func validate() ->Bool {
        
        if(self.oldpassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter current password.")
            return false
        }
        if(self.newpassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter new password.")
            return false
        }
        if(self.confirmPassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter confirm password.")
            return false
        }
        
           if(self.newpassword.text! != self.confirmPassword.text!) {
             showAlerOnTop(message: "Password doesn't match")
            return false
        }
        
        
        return true
    }
    
    
}
