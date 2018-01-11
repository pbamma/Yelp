//
//  DetailViewController.swift
//  App
//
//  Created by Philip Starner on 1/10/18.
//  Copyright © 2018 Philip Starner. All rights reserved.
//

import UIKit
import SDWebImage
import HCSStarRatingView

class DetailViewController: UIViewController {
    
    @IBOutlet weak var blurContainer: UIView!
    var blurContainerEffectView: UIVisualEffectView?
    
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dataTextView: UITextView!
    
    @IBOutlet weak var starRating: HCSStarRatingView!
    var business: Business!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBlurView()
        
        displayData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBlurView() {
        //add blur to container
        if self.blurContainerEffectView == nil {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            self.blurContainerEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurContainerEffectView!.frame = view.bounds
            self.blurContainerEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            self.blurContainer.insertSubview(self.blurContainerEffectView!, at: 0)
        }
    }
    
    func displayData() {
        
        APIManager.sharedInstance.getBusiness(id: business.id!) { (businessDetail: BusinessDetail?, error: Error?) in
            //we've got the full business
            if let businessDetail = businessDetail {
                var dataString = self.dataTextView.text!
                dataString += "\n"
                if let hours = businessDetail.hours {
                    if let isOpen = hours[0].isOpenNow, isOpen == true {
                        dataString += "Open Now: YES" + "\n"
                    } else {
                        dataString += "Open Now: NO" + "\n"
                    }
                    
                    if let open = hours[0].open {
                        let dayOfWeek = Utils.getDayOfWeek()
                        if dayOfWeek < open.count {
                            let today = open[dayOfWeek]
                            let start = Utils.fourDigitHourConverter(time: today.start)
                            let end = Utils.fourDigitHourConverter(time: today.end)
                            dataString += "Hours Open Today: \(start) - \(end)"
                        }
                    }
                }
                
                self.dataTextView.text = dataString
                
                //more accurate rating
                if let rating = businessDetail.rating {
                    self.starRating.value = CGFloat(rating)
                }
                
                
            }
            
        }
        
        self.nameLabel.text = ""
        self.nameLabel.text = self.business.name
        
        if let imageURL = business.imageUrl  {
            let url = URL(string: imageURL)
            self.imageThumb.sd_setImage(with: url)
        }
        
        if let price = business.price {
            self.priceLabel.text = price
        }
        
        if let rating = business.rating {
            self.starRating.value = CGFloat(rating)
        }
        
        var dataString = "Phone: "
        if let phone = business.displayPhone {
            dataString += phone + "\n"
        } else {
            dataString += "No Phone" + "\n"
        }
        dataString += "\n"
        
        dataString += "Address: "
        if let displayAddress = business.location?.displayAddress {
            for items in displayAddress {
                dataString += items + "\n"
            }
        } else {
            dataString += "No Address" + "\n"
        }
        
        dataTextView.text = dataString
    }

}
