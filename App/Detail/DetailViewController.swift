//
//  DetailViewController.swift
//  App
//
//  Created by Philip Starner on 1/10/18.
//  Copyright © 2018 Philip Starner. All rights reserved.
//
//  self.business is initially passed in through the segue
//  self.business is updated with more information 

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
    var business: CDBusiness!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBlurView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayData()
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
        //get some easy data on screen
        initialBusinessUIUpdate()
        
        //check our database for an updated business...
        //... if business is updated DO NOT MAKE THE API CALL
        //... users like snappy apps
        let businessIsUpdated = DatabaseManager.sharedInstance.isBusinessUpdated(businessID: business.id!)
        
        if businessIsUpdated {
            print("We've stored this business so FAST display!")
            self.business = DatabaseManager.sharedInstance.fetchBusiness(businessID: business.id!)
            self.completeBusinessUIUpdate()
        } else {
            print("This is a new business so we've got to make a network call which will display slower!")
            APIManager.sharedInstance.getBusiness(id: business.id!) { (businessDetail: BusinessDetail?, error: Error?) in
                //we've got the full business
                
                if let businessDetail = businessDetail {
                    
                    DatabaseManager.sharedInstance.updateBusinessDetail(businessID: self.business.id!, business: businessDetail)
                    self.business = DatabaseManager.sharedInstance.fetchBusiness(businessID: self.business.id!)
                    self.completeBusinessUIUpdate()
                    
                }
                
            }
        }
    }
    
    func initialBusinessUIUpdate() {
        self.nameLabel.text = ""
        self.nameLabel.text = self.business.name
        
        if let imageURL = business.imageURL  {
            let url = URL(string: imageURL)
            self.imageThumb.sd_setImage(with: url)
        }
        
        if let price = business.price {
            self.priceLabel.text = price
        }
        
        self.starRating.value = CGFloat(business.rating)
        
        var dataString = "Phone: "
        if let phone = business.phone {
            dataString += phone + "\n"
        } else {
            dataString += "No Phone" + "\n"
        }
        dataString += "\n"
        
        dataString += "Address: "
        if let displayAddress = business.address {
            dataString += displayAddress + "\n"
        } else {
            dataString += "No Address" + "\n"
        }
        
        dataTextView.text = dataString
    }
    
    func completeBusinessUIUpdate() {
        var dataString = self.dataTextView.text!
        dataString += "\n"
        if self.business.isOpenNow == true {
            dataString += "Open Now: YES" + "\n"
        } else {
            dataString += "Open Now: NO" + "\n"
        }
        if let start = self.business.hoursStart, let end = self.business.hoursEnd {
            dataString += "Hours Open Today: \(start) - \(end)"
        }
        
        self.dataTextView.text = dataString
        
        //more accurate rating
        self.starRating.value = CGFloat(self.business.rating)
    }

}
