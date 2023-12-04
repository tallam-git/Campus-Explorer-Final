//
//  gallaryImages.swift
//  CampusExplore
//
//  Created by Poojitha on 10/11/23.
//

import UIKit
import SDWebImage

var gallaryImages = [String]()
var firstTimeNot = false
class GallaryImages: UICollectionViewController {
    

    let reuseIdentifier = "imageCell"

    
    var categoryTitle : String?
 
    override func viewDidLoad() {
        firstTimeNot = false
        collectionView.registerCells([CustomCollectionViewCell.self])
        FireStoreManager.shared.fetchDataFromFirestore(collectionView: self.collectionView)
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        collectionView.collectionViewLayout = CompositionalLayout()
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                  layout.minimumInteritemSpacing = 10
                  layout.minimumLineSpacing = 10
        }
        
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallaryImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        let image = gallaryImages[indexPath.row]
        if let imageURL = URL(string:image.encodedURL()) {
            cell.galaryImage.layer.cornerRadius = 10.0
            cell.galaryImage.layer.masksToBounds = true
            cell.galaryImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: ""))
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = self.storyboard?.instantiateViewController(identifier: "FullImageVC") as! FullImageVC
        vc.imageUrl = gallaryImages[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

func CompositionalLayout() -> UICollectionViewCompositionalLayout {
    let inset: CGFloat = -10
    let interItemSpacing: CGFloat = -1
    
    let tItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(9/16))
    let tItem = NSCollectionLayoutItem(layoutSize: tItemSize)
    tItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
    
    let bItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
    let bItem = NSCollectionLayoutItem(layoutSize: bItemSize)
    bItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
    
    let bGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
    let bGroup = NSCollectionLayoutGroup.horizontal(layoutSize: bGroupSize, subitem: bItem, count: 2)
    bGroup.interItemSpacing = .fixed(interItemSpacing) // Set the inter-item spacing
    
    let gullGSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(9/16 + 0.5))
    let wholeGroup = NSCollectionLayoutGroup.vertical(layoutSize: gullGSize, subitems: [tItem, bGroup])
    
    let sec = NSCollectionLayoutSection(group: wholeGroup)
    
    let layout = UICollectionViewCompositionalLayout(section: sec)
    
    return layout
}



class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet var galaryImage: UIImageView!
}
