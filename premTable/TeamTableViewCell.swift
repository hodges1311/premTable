//
//  TeamTableViewCell.swift
//  premTable
//
//  Created by Development on 8/6/16.
//  Copyright © 2016 HodgesApps. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
   
    @IBOutlet weak var TeamCrest: UIImageView!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var teamName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
