//
//  CommonDetialsVC.swift
//  CampusExplore
//
//  Created by Poojitha on 10/11/23.
//

import UIKit

class CommonDetialsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var details = ""
    var images = [String]()
    var name = ""
    @IBOutlet weak var topTitle: UILabel!
    
    override func viewDidLoad() {
        self.tableView.registerCells([CommonSliderCell.self])
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.topTitle.text = name.capitalized
    }
}


extension CommonDetialsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommonSliderCell") as! CommonSliderCell
        cell.setCell(images: images, description:details)
        return cell
    }
   

 
     
    
}
 
