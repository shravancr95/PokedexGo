//
//  pokedexTableViewCell.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/20/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit

class pokedexTableViewCell: UITableViewCell {
    @IBOutlet weak var type2Image: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var type1Image: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
