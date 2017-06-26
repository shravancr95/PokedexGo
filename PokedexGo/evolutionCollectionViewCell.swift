//
//  evolutionCollectionViewCell.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 6/4/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit

class evolutionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var currentStage: UIImageView!
    @IBOutlet weak var evolutionImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.evolutionImage.frame = CGRect
    }
}
