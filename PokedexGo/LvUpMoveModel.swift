//
//  LvUpMoveModel.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/28/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import Foundation

class LvUpMoveModel {
    var level: Int?
    var game: String?
    var move: Move?
    
    init(move: Move, game: String?, level: Int?){
        self.move = move
        self.level = level
        self.game = game
    }
    
}
