//
//  progressDexTableViewCell.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/23/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit

class progressDexTableViewCell: UITableViewCell {

    @IBOutlet weak var pkmnIcon: UIImageView!
    @IBOutlet weak var pokeballImage: UIImageView!
    
    @IBOutlet weak var type2Image: UIImageView!
    @IBOutlet weak var type1Image: UIImageView!
    @IBOutlet weak var pokemonInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
}
