//
//  CalenderVC.swift
//  CampusExplore
//
//  Created by Vishnu on 10/11/23.
//

import UIKit

class CalenderVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var list:[Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerCells([CommonCell.self])
        self.tableView.showsVerticalScrollIndicator = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViewModel.shared.getAllEvents {  list in
            self.list = list.sorted { (data1, data2) -> Bool in
                return data1.date.compare(data2.date) == .orderedAscending
            }
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onAddEvent(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AddEventVC" ) as! AddEventVC
                    
            self.navigationController?.pushViewController(vc, animated: true)
        }

}



extension CalenderVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let list = list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.eventName.text = "Event Name : \(list.eventName)"
        cell.eventDate.text = "Event Date : \(list.date)"
        cell.eventDescription.text = "Event Description : \(list.description)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = list[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AddEventVC" ) as! AddEventVC
                
        vc.eventRecord = list
        vc.editEvent = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // UITableViewDelegate method for handling cell deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCell(at: indexPath)
        }
    }
    
    // Function to delete a cell
     func deleteCell(at indexPath: IndexPath) {
         let listData = list[indexPath.row]
         list.remove(at: indexPath.row)
         FireStoreManager.shared.deleteEvent(eventName: listData.eventName, date: listData.date) { success in
             if success {
                 showAlerOnTop(message: "Event deleted successfully")
             }
         }
         tableView.deleteRows(at: [indexPath], with: .fade)
     }
}

