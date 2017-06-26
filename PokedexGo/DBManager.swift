//
//  DBManager.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/22/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import Foundation
import SQLite
class Ability{
    var name: String
    var isHidden: Bool
    var effect: String?
    init(name: String, isHidden: Int, effect: String){
        if isHidden == 0 {
            self.isHidden = false
        }
        else {
            self.isHidden = true
        }
        self.name = name
        self.effect = effect
    }
}

class DBManager{
    //static let shared: DBManager = DBManager()
    var db: Connection?
    let path = Bundle.main.path(forResource: "pokedexGoData", ofType: "db")!
    let tblProgress = Table("PokedexProgress")
    
    //let db = try Connection(path, readonly: true)
    init(){
        do{
            db = try Connection(path, readonly: false)
            //db.open
            //createTableProduct()
        }
        catch{
            db = nil
            print("DB unable to be connected")
        }
    }
    
    func querySpecialPokemonLocation(id: Int) -> [filteredData]{
        var result:[filteredData] = []
        let table = Table("special_pokemon").filter(Expression<Int64>("pokemon_id") == Int64(id))
        //print("id: \(id)")
        do{
            print("do")
            for encounters in try (db?.prepare(table))!{
                //print("loop")
                //print("dat : \(encounters[Expression<String>("version")]) : \(encounters[Expression<String>("location")])")
                result.append(filteredData(location: encounters[Expression<String>("location")], version: encounters[Expression<String>("version")], min_level: Int(encounters[Expression<Int64>("min_level")]), max_level: Int(encounters[Expression<Int64>("max_level")]), method: encounters[Expression<String>("encounter_method")], condition: encounters[Expression<String>("conditions")], maxChance: 100))
            }
        }
        catch{
            print(error.localizedDescription)
        }
        //print("num locations : \(result.count)")
        return result
    }
    
    func setMachineID(tmMoves: [TMModel]){
        for items in tmMoves{
            let tmTable = Table("tm_hm").filter(Expression<String>("version") == items.game! && Expression<String>("move") == (items.move?.name)!)
            do {
                if let tm = try db?.pluck(tmTable) {
                    items.setTMNum(tmNum: Int(tm[Expression<Int64>("machine_number")]))  
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func queryAllMoves() -> [String:Move]{
        var result = [String:Move]()
        let movesTable = Table("Moves")
        do{
            for moves in try (db?.prepare(movesTable))!{
                //print("iterating for")
                //print("\(pkmn[Expression<Int64>("ID")]):\(pkmn[Expression<String>("Name")])")
                //print(moves[Expression<String>("Move")])
                
                let Name: String = moves[Expression<String>("Move")]
                let Type: String = moves[Expression<String>("Type")]
                let Description: String = moves[Expression<String>("Description")]
                let Category: String = moves[Expression<String>("Category")]
                let Power: Int = moves[Expression<Int>("Power")]
                let Accuracy: String = moves[Expression<String>("Accuracy")]
                let PP: Int = moves[Expression<Int>("PP")]
                let ID: Int = moves[Expression<Int>("ID")]
                let m = Move(moveID: ID, name: Name, power: Power, accuracy: Accuracy, type: Type, effect: Description, pp: PP)
                result[Name] = m
            }
        }
        catch{
            print("DB cant be queried")
        }
        
        //print("Total of \(result.count) moves")
        
        return result
    }
    
    func generateAbilityData(pokemonID: Int) -> [Ability] {
        var abilityData = [Ability]()
        let ability = Table("abilities_final").filter((Expression<Int64>("pokemon_id")) == Int64(pokemonID))
        do {
            for abilities in try (db?.prepare(ability))!{
                abilityData.append(Ability(name: abilities[Expression<String>("identifier")], isHidden: Int(abilities[Expression<Int64>("is_hidden")]), effect: abilities[Expression<String>("effect")].replacingOccurrences(of: "\n", with: " ")))
                //print(abilityData[abilityData.count-1].name)
            }
        }
        catch{
            print(error.localizedDescription)
        }
        return abilityData
    }
    
    func queryAllPokemon() -> [PokemonModel]{
        let pkmnTable = Table("Pokemon").group(Expression<Int64>("ID"))
        pkmnTable.group(
            Expression<Int64>("ID")
        )
        //pkmnTable.filter(Expression<String>("Name").like("%Mega"))
        var pkmnList = [PokemonModel]()
        do{
            print("querying db")
            for pkmn in try (db?.prepare(pkmnTable))!{
                //print("iterating for")
                //print("\(pkmn[Expression<Int64>("ID")]):\(pkmn[Expression<String>("Name")])")
                pkmnList.append(PokemonModel(n: pkmn[Expression<String>("Name")], i: Int(pkmn[Expression<Int64>("ID")]), t1: pkmn[Expression<String>("Type1")], t2: pkmn[Expression<String>("Type2")], evolutionID: Int(pkmn[Expression<Int64>("evo_chain_id")]), hp: Int(pkmn[Expression<Int64>("HP")]), atk: Int(pkmn[Expression<Int64>("Atk")]), def: Int(pkmn[Expression<Int64>("Def")]), spAtk: Int(pkmn[Expression<Int64>("SpAtk")]), spDef: Int(pkmn[Expression<Int64>("SpDef")]), spd: Int(pkmn[Expression<Int64>("Spd")]) )
                )
            }
        }
        catch{
            print("DB cant be queried")
        }
        return pkmnList
    }
    
    func createProgressTable(){
        let tblProgress = Table("PokedexProgress")
        do{
            try db!.run(tblProgress.create(ifNotExists: true){table in
                    table.column(Expression<Int64>("ID"))
                    table.column(Expression<String>("Name"))
                    table.column(Expression<String>("Type1"))
                    table.column(Expression<String>("Type2"))
                    table.column(Expression<Bool>("caught"))
            })
            //insertInitialProgressData()
            do{
                print("querying db")
                for pkmn in try (db?.prepare(tblProgress))!{
                    //print("iterating for")
                    //print("\(pkmn[Expression<Int64>("ID")]):\(pkmn[Expression<String>("Name")])")
                    /*pkmnList.append(PokemonModel(n: pkmn[Expression<String>("Name")], i: Int(pkmn[Expression<Int64>("ID")]), t1: pkmn[Expression<String>("Type1")], t2: pkmn[Expression<String>("Type2")])
                    )*/
                    print("\(Int(pkmn[Expression<Int64>("ID")])):\(pkmn[Expression<String>("Name")])")
                }
            }
            catch{
                print("DB cant be queried")
            }

        }
        catch{
            print("cannot create table")
        }
    }
    
    func insertInitialProgressData(){
        var pokemonData = queryAllPokemon()
        for data in pokemonData{
            do{
                try db?.transaction{
                    let rowid = try self.db?.run(self.tblProgress.insert(Expression<Int64>("ID") <- Int64(data.ID), Expression<String>("Name") <- data.name, Expression<String>("Type1")<-data.type1, Expression<String>("Type2") <- data.type2))
                    print("inserted \(data.ID):\(data.name) with rowID = \(rowid)")
                }
            }
            catch{
                print("insert failed")
            }
        }
    }
    
}
