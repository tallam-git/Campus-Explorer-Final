//
//  FacultyVC.swift
//  CampusExplore
//
//  Created by Poojitha on 17/11/23.
//

import UIKit
import AVKit

class FacultyVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var list: [Faculty] = [] {
           didSet {
               // Sort the list based on favorites and then by name
               list = list.sorted { (faculty1, faculty2) -> Bool in
                   let isFav1 = UserDefaultsManager.shared.getFavorites(title: faculty1.name)
                   let isFav2 = UserDefaultsManager.shared.getFavorites(title: faculty2.name)

                   // First, sort by favorites
                   if isFav1 && !isFav2 {
                       return true
                   } else if !isFav1 && isFav2 {
                       return false
                   }

                   // If both are favorites or both are not favorites, then sort by name
                   return faculty1.name.localizedCompare(faculty2.name) == .orderedAscending
               }
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerCells([CommonCell.self])
        self.tableView.showsVerticalScrollIndicator = false
        ViewModel.shared.getAllFaculties {  list in
            self.list = list
            self.tableView.reloadData()
        }
    }

}



extension FacultyVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let list = list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath) as! CommonCell
        cell.setData(title: list.name, imageUrl: list.image)
//        cell.commonImage.layer.cornerRadius = 60
//        cell.commonImage.layer.borderWidth = 1
//        cell.commonImage.layer.borderColor = UIColor.gray.cgColor
        let isFavourite = UserDefaultsManager.shared.getFavorites(title: list.name)
        if(isFavourite ) {
            cell.heart.setImage(UIImage(systemName:"heart.fill"), for: .normal)
            
        }else {
            cell.heart.setImage(UIImage(systemName:"heart"), for: .normal)
            
        }
        
        cell.heart.onTap {
            if  UserDefaultsManager.shared.getFavorites(title: list.name) {
                UserDefaultsManager.shared.removeFavorite(title: list.name)
                AudioServicesPlaySystemSound(1109)
            } else {
                UserDefaultsManager.shared.saveFavourite(title: list.name)
                AudioServicesPlaySystemSound(1152)
            }
            self.tableView.reloadData()
            
            // Sort and reload the table view
                self.list = self.list.sorted { (faculty1, faculty2) -> Bool in
                    let isFav1 = UserDefaultsManager.shared.getFavorites(title: faculty1.name)
                    let isFav2 = UserDefaultsManager.shared.getFavorites(title: faculty2.name)
                    return isFav1 && !isFav2
                }
                self.tableView.reloadData()
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let list = self.list[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(identifier: "CommonDetialsVC") as! CommonDetialsVC
        vc.name = list.name
        vc.details = "\(list.about) \n\nSubject : \(list.subject ?? "")"
        vc.images = [list.image]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

 
