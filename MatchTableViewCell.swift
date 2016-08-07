//
//  MatchTableViewCell.swift
//  
//
//  Created by Development on 8/7/16.
//
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var away: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var homeCrest: UIImageView!
    @IBOutlet weak var awayCrest: UIImageView!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
