//
//  AddEventVC.swift
//  CampusExplore
//
//  Created by Poojitha on 17/11/23.
//

import UIKit

class AddEventVC: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDecription: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var datebtn: UIButton!
    @IBOutlet weak var editTitle: UILabel!
    @IBOutlet weak var editBtn: UIButton!

    let datePicker = UIDatePicker()
    let reuseIdentifier = "DayCell"
    let daysInWeek = 7
    var currentDate: Date!
    var daysInMonth: Int!
    var selectedDate: Date? {
        didSet {
            updateSelectedDateLabel()
        }
    }
    
    var eventRecord : Event?
    var editEvent = false

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var selectedDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addCalender()
        eventDecription.delegate = self
        self.datebtn.isHidden = true
        self.editTitle.text = "Add Event"
        self.editBtn.setTitle("Add Event", for: .normal)
        
        if editEvent {
            self.stackView.isHidden = true
            self.collectionView.isHidden = true
            self.datebtn.isHidden = false

            self.selectedDateLabel.text = self.eventRecord?.date
            self.eventName.text = self.eventRecord?.eventName
            self.eventDecription.text = self.eventRecord?.description
            self.eventDecription.textColor = .black
            self.editTitle.text = "Edit Event"
            self.editBtn.setTitle("Update Event", for: .normal)
        }
    }
    
    @IBAction func onShowCalender(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.stackView.isHidden = false
            self.collectionView.isHidden = false
        }
    }
    
    func addCalender(){
        currentDate = Date()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        updateMonthLabel()

        updateSelectedDateLabel()
    }
    
    
    @IBAction func onAddEvent(_ sender: Any) {
        if validate(){
            
            if editEvent {
                var timeStamp = 0.0
                if selectedDate != nil{
                    timeStamp = getTime(date: selectedDate!)
                } else {
                    timeStamp = self.eventRecord?.dateTimeStamp ?? 0.0
                }
                            
                var event = Event(description: self.eventDecription.text ?? "", eventName: self.eventName.text ?? "", date: self.selectedDateLabel.text ?? "", dateTimeStamp:  timeStamp)

                let eventData = ["description": self.eventDecription.text ?? "", "eventName": self.eventName.text ?? "", "date": self.selectedDateLabel.text ?? "", "dateTimeStamp":  timeStamp] as [String : Any]
                
                self.getEventDocumentId { documentId in
                    FireStoreManager.shared.updateEventDetail(documentid: documentId, eventData: eventData) { success in
                        if success{
                            showAlerOnTop(message: "Event updated successfully")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            else {
                
                let timeStamp = getTime(date: selectedDate!)
                var event = Event(description: self.eventDecription.text ?? "", eventName: self.eventName.text ?? "", date: self.selectedDateLabel.text ?? "", dateTimeStamp:  timeStamp)
                
                FireStoreManager.shared.addEvent(event: event) { success in
                    if success{
                        
                        showOkAlertAnyWhereWithCallBack(message: "Event added Successfully!") {
                            
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func getEventDocumentId(completion: @escaping (String)->()){
        FireStoreManager.shared.getDocumentId(forEventName: self.eventRecord?.eventName ?? "", eventDate: self.eventRecord?.date ?? "") { (documentId, error) in
            if let error = error {
                print("Error fetching document ID: \(error)")
            } else if let documentId = documentId {
                completion(documentId)
                print("Document ID: \(documentId)")
            } else {
                print("No matching document found")
            }
        }

    }
    
    func getTime(date:Date)-> Double {
            return Double(date.millisecondsSince1970)
        }
    
    func validate() ->Bool {
        
        if(self.eventName.text!.isEmpty) {
            showAlerOnTop(message: "Please enter event name.")
            return false
        }
        
        
        if(self.selectedDateLabel.text == "No Event selected") {
            showAlerOnTop(message: "Please select date.")
            return false
        }
        
        if(self.eventDecription.text!.isEmpty) {
            showAlerOnTop(message: "Please enter decription")
            return false
        }
        
        
        if(self.eventDecription.text == "Event Description") {
            showAlerOnTop(message: "Please enter description")
            return false
        }
        
        return true
    }
    
}


extension AddEventVC {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Event Description" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Event Description"
            textView.textColor = UIColor.lightGray
        }
        
    }
}

extension AddEventVC {
    @IBAction func previousMonthButtonTapped(_ sender: Any) {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        updateMonthLabel()
        collectionView.reloadData() // Reload collection view to avoid overlapping values
    }
        
        @IBAction func nextMonthButtonTapped(_ sender: Any) {

        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        updateMonthLabel()
        collectionView.reloadData() // Reload collection view to avoid overlapping values
    }
    
    func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        monthLabel.text = formatter.string(from: currentDate)
        daysInMonth = Calendar.current.range(of: .day, in: .month, for: currentDate)?.count
    }
    
    func updateSelectedDateLabel() {
        if let selectedDate = selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy"
            selectedDateLabel.text = "\(formatter.string(from: selectedDate))"
        } else {
            selectedDateLabel.text = "No Event selected"
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = "\(indexPath.item + 1)"
        label.textAlignment = .center
        
        cell.contentView.addSubview(label)
        
        cell.contentView.backgroundColor = isSelected(indexPath) ? UIColor.systemMint : UIColor.lightGray
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = UIColor.lightGray
    }
    
    func isSelected(_ indexPath: IndexPath) -> Bool {
        return collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDay = indexPath.item + 1
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let selectedDateCandidate = calendar.date(from: components)?.addingTimeInterval(TimeInterval(60 * 60 * 24 * (selectedDay - 0)))

        // Check if the selected date is in the past
        guard let selectedDate = selectedDateCandidate, selectedDate >= Date() else {
            // If it's in the past, do not select and return
            showAlerOnTop(message: "You can't select previous date")
            return
        }

        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = UIColor.systemMint

        // Update the selected date when a valid date is tapped
        self.selectedDate = calendar.date(from: components)?.addingTimeInterval(TimeInterval(60 * 60 * 24 * (selectedDay - 1)))
    }
    
}

