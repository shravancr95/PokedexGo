//
//  TMModel.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/28/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import Foundation

class TMModel{
    var machineType: String?
    var TMID: Int?
    var TMNum: Int?
    var move: Move?
    var game: String?
    
    init(move: Move, game: String){
        self.move = move
        self.game = game
    }
    
    func setTMNum(tmNum: Int){
        TMID = tmNum
        if tmNum <= 100 {
            TMNum = tmNum
            machineType = "TM"
        }
        else {
            TMNum = tmNum - 100
            machineType = "HM"
        }
    }
    
}
