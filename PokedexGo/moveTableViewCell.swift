//
//  moveTableViewCell.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/28/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit

class moveTableViewCell: UITableViewCell {

    @IBOutlet weak var moveEffectTextView: UITextView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var ppLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
