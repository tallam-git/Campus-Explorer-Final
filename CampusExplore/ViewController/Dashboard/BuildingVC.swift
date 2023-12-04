//
//  BuildingVC.swift
//  CampusExplore
//
//  Created by Poojitha on 17/11/23.
//

import UIKit
import AVKit

class BuildingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var campusBuildings: [CampusBuilding] = [] {
        didSet {
            // Sort the list based on favorites and then by name
            campusBuildings = campusBuildings.sorted { (building1, building2) -> Bool in
                let isFav1 = UserDefaultsManager.shared.getFavorites(title: building1.name)
                let isFav2 = UserDefaultsManager.shared.getFavorites(title: building2.name)

                // First, sort by favorites
                if isFav1 && !isFav2 {
                    return true
                } else if !isFav1 && isFav2 {
                    return false
                }

                // If both are favorites or both are not favorites, then sort by name
                return building1.name.localizedCompare(building2.name) == .orderedAscending
            }
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerCells([CommonCell.self])
        
        ViewModel.shared.getAllBuildings {  list in
            self.campusBuildings = list
            self.tableView.reloadData()
        }
    }

}



extension BuildingVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campusBuildings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let campus = campusBuildings[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath) as! CommonCell
        cell.setData(title: campus.name, imageUrl: campus.images.first ?? commonUrl)
        
        let isFavourite = UserDefaultsManager.shared.getFavorites(title: campus.name)
        if(isFavourite ) {
            cell.heart.setImage(UIImage(systemName:"heart.fill"), for: .normal)
            AudioServicesPlaySystemSound(1109)
        }else {
            cell.heart.setImage(UIImage(systemName:"heart"), for: .normal)
            AudioServicesPlaySystemSound(1152)
        }
        
     
        cell.heart.onTap {
            if  UserDefaultsManager.shared.getFavorites(title: campus.name) {
                UserDefaultsManager.shared.removeFavorite(title: campus.name)
            } else {
                UserDefaultsManager.shared.saveFavourite(title: campus.name)
            }
            self.tableView.reloadData()
            
            // Sort and reload the table view
                self.campusBuildings = self.campusBuildings.sorted { (campus1, campus2) -> Bool in
                    let isFav1 = UserDefaultsManager.shared.getFavorites(title: campus1.name)
                    let isFav2 = UserDefaultsManager.shared.getFavorites(title: campus2.name)
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
       
        let data = self.campusBuildings[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(identifier: "CommonDetialsVC") as! CommonDetialsVC
        vc.name = data.name.capitalized
        vc.details = data.details
        vc.images = data.images
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
