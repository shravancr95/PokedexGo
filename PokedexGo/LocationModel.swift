//
//  LocationModel.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 6/9/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import Foundation

/*class EncounterDetails {
    var route: String?
    var method: String?
    var maxLevel: Int?
    var minLevel: Int?
    var chance: Int?
    var condition: String?
    init(route: String?, method: String?, maxLevel: Int?, minLevel: Int, chance: Int?, condition: String?){
        self.route = route
        self.method = method
        self.maxLevel = maxLevel
        self.minLevel = minLevel
        self.chance = chance
        self.condition = condition
    }
}

class Location {
    var game: String?
    var encounterMethod: String?
    var condition: String?
    var location: String?
    var levels: [Int] = []
    //var minLevel: Int?
    //var maxLevel: Int?
    //var details: [EncounterDetails] = []
    
    init(game: String?, encounterMethod: String?, condition: String?, location: String?) {
        self.game = game
        self.encounterMethod = encounterMethod
        if condition == ""{
            self.condition = "None"
        }
        else {
            self.condition = condition
        }
        self.location = location
        //self.minLevel = minLevel
        //self.maxLevel = maxLevel
    }
}*/

class EncounterDetails{
    var minLv: Int?
    var maxLv: Int?
    var conditions: [String] = []
    var method: String?
    var chance: Int?
    init(minLv: Int?, maxLv: Int?, method:String?, chance: Int?){
        self.minLv = minLv
        self.maxLv = maxLv
        self.chance = chance
        self.method = method
    }
}

class VersionDetail{
    var version: String?
    var maxChance: Int?
    var encounterDetails: [EncounterDetails] = []
    init(version: String?, maxChance: Int?){
        self.version = version
        self.maxChance = maxChance
    }
}

class EncountersData {
    var location: String?
    var versionDetails: [VersionDetail] = []
    init(location: String?){
        self.location = location
    }
}
