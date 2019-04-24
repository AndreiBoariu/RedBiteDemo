//
//  ContribuitorInfoCell.swift
//  RedBiteDemo
//
//  Created by Boariu Andy on 4/24/19.
//  Copyright © 2019 RedBite Inc. All rights reserved.
//

import UIKit
import Kingfisher

class ContribuitorInfoCell: UITableViewCell {
    
    @IBOutlet weak var imgvContribuitor: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContributorsCount: UILabel!
    
    static var cellID = "ContribuitorInfoCellID"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadContribuitorInfo(_ contribuitor: Contribuitor) {
        lblName.text = contribuitor.name
        lblContributorsCount.text = "Number of commits: \(contribuitor.commits)"
        
        if let strImageUrl = contribuitor.imgUrl,
            let url = URL(string: strImageUrl) {
            imgvContribuitor.kf.setImage(
                with: url,
                options: [.transition(ImageTransition.fade(1))]
            )
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
