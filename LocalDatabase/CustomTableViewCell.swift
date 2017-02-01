//
//  CustomTableViewCell.swift
//  LocalDatabase
//
//  Created by Shilp_m on 1/24/17.
//  Copyright © 2017 Shilp_mphoton pho. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLable: UILabel!
    @IBOutlet weak var cellTimeLable: UILabel!
    @IBOutlet weak var cellEditButton: UIButton!
    @IBOutlet weak var cellStatusLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
