//
//  evolutionTableViewCell.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/31/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit

class evolutionTableViewCell: UITableViewCell {
    

    @IBOutlet weak var evolutionDetails: UILabel!
    @IBOutlet weak var evolutionImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
