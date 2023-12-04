//
//  CalenderDesignVC.swift
//  CampusExplore
//
//  Created by Vishnu on 10/11/23.
//


import UIKit

class CalenderDesignVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let reuseIdentifier = "DayCell"
        let daysInWeek = 7
        var currentDate: Date!
        var daysInMonth: Int!
        var selectedDate: Date? {
            didSet {
                updateSelectedDateLabel()
            }
        }
        
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var monthLabel: UILabel!
        @IBOutlet weak var selectedDateLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set up initial date and number of days in the month
            currentDate = Date()
            
            // Configure the collection view
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            
            // Update month label
            updateMonthLabel()
            
            // Add previous and next month buttons
            let previousMonthButton = UIButton(type: .system)
            previousMonthButton.setTitle("Previous Month", for: .normal)
            previousMonthButton.addTarget(self, action: #selector(previousMonthButtonTapped), for: .touchUpInside)
            
            let nextMonthButton = UIButton(type: .system)
            nextMonthButton.setTitle("Next Month", for: .normal)
            nextMonthButton.addTarget(self, action: #selector(nextMonthButtonTapped), for: .touchUpInside)
            
            let stackView = UIStackView(arrangedSubviews: [previousMonthButton, monthLabel, nextMonthButton])
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.spacing = 8.0
            
            view.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0)
            ])
            
            // Add selected date label
            selectedDateLabel.textAlignment = .center
            view.addSubview(selectedDateLabel)
            selectedDateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                selectedDateLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16.0),
                selectedDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            // Initial update of the selected date label
            updateSelectedDateLabel()
        }
        
        @objc func previousMonthButtonTapped() {
            currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
            updateMonthLabel()
            collectionView.reloadData() // Reload collection view to avoid overlapping values
        }
        
        @objc func nextMonthButtonTapped() {
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
                selectedDateLabel.text = "Selected Date: \(formatter.string(from: selectedDate))"
            } else {
                selectedDateLabel.text = "No date selected"
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
        
        cell.contentView.backgroundColor = isSelected(indexPath) ? UIColor.systemCyan : UIColor.lightGray
        
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
            collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = UIColor.blue

            // Update the selected date when a cell is tapped
            let selectedDay = indexPath.item + 1
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: currentDate)
            selectedDate = calendar.date(from: components)?.addingTimeInterval(TimeInterval(60 * 60 * 24 * (selectedDay - 1)))
        }
       
}
