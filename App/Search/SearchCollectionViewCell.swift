//
//  SearchCollectionViewCell.swift
//  App
//
//  Created by Philip Starner on 1/10/18.
//  Copyright © 2018 Philip Starner. All rights reserved.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageThumb.layer.cornerRadius = 6
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageThumb.image = nil
        nameLabel.text = ""
    }
    
    func loadModel(business: CDBusiness) {
        self.nameLabel.text = business.name
        if let imageURL = business.imageURL  {
            let url = URL(string: imageURL)
            self.imageThumb.sd_setImage(with: url)
        }
    }
}
