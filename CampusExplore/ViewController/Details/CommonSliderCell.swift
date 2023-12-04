//
//  CommonSliderCell.swift
//  CampusExplore
//
//  Created by Poojitha on 10/11/23.
//

import UIKit
import SDWebImage
 
class CommonSliderCell: UITableViewCell {
    
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    var images = [String]()
    
    func setCell(images:[String],description:String) {
        self.images = images
        self.des.text = description
        self.setupImageSlideShow()
        
    }

}


extension CommonSliderCell {
    
    
    func setupImageSlideShow() {
        
        let sdWebImageSource = self.images.compactMap { image -> SDWebImageSource? in
            return SDWebImageSource(url: URL(string:  image.encodedURL())!)
        }
    
        imageSlideShow.slideshowInterval = 5.0
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleToFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageSlideShow.pageIndicator = pageControl
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.delegate = self
        imageSlideShow.setImageInputs(sdWebImageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSlideShow.addGestureRecognizer(recognizer)
        
        
    }
    
    @objc func didTap() {
      //  let fullScreenController = imageSlideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        //fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }

    
}



extension CommonSliderCell: ImageSlideshowDelegate {
    
func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
   
}
}
