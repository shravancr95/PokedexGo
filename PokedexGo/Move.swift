//
//  Move.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/27/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import Foundation
import Alamofire
class Move{
    var moveID: Int?
    var effect: String?
    var url: String?
    var level: Int?
    var name: String?
    var power: Int?
    var accuracy: String?
    var type: String?
    var pp: Int?
    var game: String?
    var method: String?
    var isHM: Bool = false
    enum methodOfLearning: String{
        case EGG = "egg"
        case LEVEL = "level-up"
        case TM = "machine"
        case TUTOR = "tutor"
    }
    var tmNumber: Int?
    
    //var gameTag: String //which game the move can be learned
    //var methodTag: String //which method, EGG, LEVEL, or TM
    
    init(name: String, game: String, method: String, url: String, level: Int){
        self.name = name
        self.game = game
        //self.method = method
        self.url = url
        if method == "machine" {
            self.method = methodOfLearning.TM.rawValue
        }
        if method == "egg" {
            self.method = methodOfLearning.EGG.rawValue
        }
        if method == "level-up"{
            self.method = methodOfLearning.LEVEL.rawValue
        }
        if method == "tutor"{
            self.method = methodOfLearning.TUTOR.rawValue
        }
        self.level = level
        
        
    }
    
    
    init(moveID: Int?, name: String, power: Int, accuracy: String, type: String, effect: String?, pp: Int?) {
        //self.level = level
        self.moveID = moveID
        self.effect = effect
        self.name = name
        self.power = power
        self.accuracy = accuracy
        self.type = type
        self.power = power
        self.pp = pp
    }
    
}
