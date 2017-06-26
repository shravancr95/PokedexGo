
//
//  PokemonModel.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/19/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class PokemonModel{
    var evolutionID: Int?
    var name:String = ""
    var ID:Int = 0
    var type1: String = ""
    var type2: String = ""
    var ability: String?
    var moveList: [Move] = []
    var eggMoves = [Move]()
    var tmMoves = [TMModel]()
    var lvUpMoves = [LvUpMoveModel]()
    var evolutionChainArray: [[String]] = [[String](), [String](), [String]()]
    var hp: Int
    var atk: Int
    var def: Int
    var spAtk: Int
    var spDef: Int
    var spd: Int
    var abilities: [Ability] = []
    
    
    /*var frlg_moves: [Move]
    var rs_moves: [Move]
    var e_moves: [Move]
    var dp_moves: [Move]
    var pt_moves: [Move]
    var hgss_moves: [Move]
    var bw_moves: [Move]
    var bw2_moves: [Move]
    var xy_moves: [Move]
    var oras_moves: [Move]
    var sunmoon_moves: [Move]*/
    
    init(n: String, i: Int, t1: String, t2: String, evolutionID: Int, hp: Int, atk: Int, def: Int, spAtk: Int, spDef: Int, spd: Int){
        name = n
        ID = i
        type1 = t1
        type2 = t2
        self.evolutionID = evolutionID
        self.hp = hp
        self.atk = atk
        self.def = def
        self.spAtk = spAtk
        self.spDef = spDef
        self.spd = spd
        //loadMoves(game: nil, moveDict: moveDict)
    }
    
    
    func getEvolutionData(){
        let evoChainURL = "\(apiURL)evolution-chain/\((evolutionID))/"
//        Alamofire.request("\(apiURL)pokemon-species/\((ID))/").responseJSON{
//            response in
//            let json = JSON(response.result.value!)
//            let evoChainURL = json["evolution_chain"]["url"].stringValue
            Alamofire.request(evoChainURL).responseJSON{
                evoResponse in
                let evoJson = JSON(evoResponse.result.value!)
                print("stage 1: \(evoJson["chain"]["species"]["name"].stringValue)")
                self.evolutionChainArray[0].append(evoJson["chain"]["species"]["name"].stringValue)
                if evoJson["chain"]["evolves_to"] != nil {
                    for (_,value) in evoJson["chain"]["evolves_to"]{
                        print("stage 2: \(value["species"]["name"])")
                        self.evolutionChainArray[1].append(value["species"]["name"].stringValue)
                        for(_, value_3) in value["evolves_to"]{
                            print("stage 3: \(value_3["species"]["name"])")
                           self.evolutionChainArray[2].append(value_3["species"]["name"].stringValue)
                        }
                    }
                }
            }
        //}
    }

    
    func loadMoves(game: String?){
        //var path = Bundle.main.url(forResource: "1", withExtension: "json")
        print("loading moves")
        Alamofire.request("\(apiURL)pokemon/\(ID)/").responseJSON{
            response in
            do{
                //let json = JSON(data: try Data(contentsOf: path!))
                //print(response.result.value!)
                let json = JSON(response.result.value!)
                if(json == nil){
                    print("json is nil")
                }
                for (move_key, move_value) in json["moves"]{
                    let moveModel: Move = moveDict[move_value["move"]["name"].stringValue]!
                    for (version_key, version_value) in move_value["version_group_details"]{
                        if (version_value["move_learn_method"]["name"].stringValue == "level-up"){
                            let level = version_value["level_learned_at"].intValue
                            let version = version_value["version_group"]["name"].stringValue
                            
                            let levelUpMove: LvUpMoveModel = LvUpMoveModel.init(move: moveModel, game: version, level: level)
                            self.lvUpMoves.append(levelUpMove)
                        }
                        else if (version_value["move_learn_method"]["name"].stringValue == "machine"){
                            let version = version_value["version_group"]["name"].stringValue
                            
                            let tmMove: TMModel = TMModel.init(move: moveModel, game: version)
                            
                            self.tmMoves.append(tmMove)
                        }
                        else if (version_value["move_learn_method"]["name"].stringValue == "egg"){
                            let tempMove = Move(moveID: moveModel.moveID, name: moveModel.name!, power: moveModel.power!, accuracy: moveModel.accuracy!, type: moveModel.type!, effect: moveModel.effect!, pp: moveModel.pp!)
                            //print("\(tempMove.name!) - \(tempMove.effect!) - \(tempMove.power!) - \(tempMove.accuracy!) - \(tempMove.type!) - \(tempMove.effect!) - \(tempMove.pp)")
                            tempMove.game = version_value["version_group"]["name"].stringValue
                            //print("obtained in game -> \(tempMove.game!)")
                            self.eggMoves.append(tempMove)
                        }
                        else {
                            //print("not added")
                        }
                    }
                }
                
            }
            catch{
                print(error.localizedDescription)
            }
            dbm.setMachineID(tmMoves: self.tmMoves)
            
            
        }
        print("total -> egg moves : \(self.eggMoves.count) \n level up moves : \(self.lvUpMoves.count) tm moves: \(self.tmMoves.count)")
    }
    
        
    func loadTMMoves(moveDict: [String:Move]){
        //let dbm = DBManager()
        var path = Bundle.main.url(forResource: "1", withExtension: "json")
    }
    
    func loadMoves(){
        var path = Bundle.main.url(forResource: "1", withExtension: "json")
        
        do{
            let json = JSON(data: try Data(contentsOf: path!))
            //let items = json["moves"][0]
            for (move_key, move_value) in json["moves"] {
                let move: String = move_value["move"]["name"].stringValue
                let url: String = move_value["move"]["url"].stringValue
                for (version_key, version_value) in move_value["version_group_details"] {
                    
                    let game_version: String = version_value["version_group"]["name"].stringValue
                    let level: Int = Int(version_value["level_learned_at"].stringValue)!
                    let method: String = version_value["move_learn_method"]["name"].stringValue
                    let m = Move(name: move, game: game_version, method: method, url: url, level: level)
                    //print("Method of learning \(move) in \(game_version) is through \(m.method)")
                    moveList.append(m)
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        print("bulbasaur has \(moveList.count) moves it can learn in total")
    }
    
    func getEvolutionLine(){
        
    }
    
    func parseDetailsForMove(index: Int){
        
        Alamofire.request(moveList[index].url!).responseJSON{
            response in
             let json = JSON(response.result.value!)
             //print("JSON: \(json)\n")
             self.moveList[index].power = json["power"].intValue
             self.moveList[index].accuracy = json["accuracy"].stringValue
             self.moveList[index].type = json["type"]["name"].stringValue
             self.moveList[index].pp = json["pp"].intValue
             self.moveList[index].effect = json["effect_entries"][0]["short_effect"].stringValue
            if json["machines"].count > 0 {
                //if json["machines"][]
            }
            /*print("/n")
             print("Power = \(self.moveList[index].attack!)")
             print("Accuracy = \(self.moveList[index].accuracy!)")
             print("Type = \(self.moveList[index].type!)")
             print("PP = \(self.moveList[index].pp!)")
             print("Effect = \(self.moveList[index].effect!)")*/
        }
    }
    //}
    
}
