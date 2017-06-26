//
//  LocationsTableViewCell.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 6/9/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chanceLabel: UILabel!
    @IBOutlet weak var methodLabel: UITextView!
    //@IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var locationAreaLabel: UILabel!
    @IBOutlet weak var levelRangeLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
