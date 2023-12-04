//
//  AdminHomeVC.swift
//  CampusExplore
//
//  Created by Charan on 01/12/23.
//


import UIKit

class AdminHomeVC: UIViewController {

    
    
    @IBAction func onAddBuilding(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddInfoVC") as! AddInfoVC
        vc.moveFrom = "Building"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onAddProfessor(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddInfoVC") as! AddInfoVC
        vc.moveFrom = "Professor"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
