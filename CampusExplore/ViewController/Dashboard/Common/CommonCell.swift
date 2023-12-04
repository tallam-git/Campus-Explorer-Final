//
//  CommonCell.swift
//  CampusExplore
//
//  Created by Charan on 21/11/23.
//

import UIKit
import SDWebImage

class CommonCell: UITableViewCell {

    @IBOutlet weak var commonTitle: UILabel!
    @IBOutlet weak var commonImage: UIImageView!
    @IBOutlet weak var heart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setData(title:String,imageUrl:String,isFav:Bool = false )  {
        
        self.commonTitle.text = title.capitalized
        self.commonImage.sd_setImage(with: imageUrl.encodedURL().toURL() ?? commonUrl.encodedURL().toURL()!, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            self.commonImage.image =  image
        })
        
    }
    
}

var commonUrl = "https://firebasestorage.googleapis.com/v0/b/campus-explorer-4c66e.appspot.com/o/others%2Fpersomn.png?alt=media&token=cfdb2747-58aa-4f06-988d-df85a6ef54be"
