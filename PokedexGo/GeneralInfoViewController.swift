//
//  GeneralInfoViewController.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/27/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct evolutionChain{
    var stage: Int?
    var pokemonInStage: [String]?
    var method: String?
}

class entry {
    var pokedexEntry: String?
    var source: String?
    init(pokedexEntry: String, source: String){
        self.pokedexEntry = pokedexEntry
        self.source = source
    }
}

class Evolution {
    var pokemonID: Int?
    var pokemonName: String?
    var evoType: String?
    var evolutionMethod: String?
    var evolutionLevel: Int?
    init(name: String?, evoType: String?, evoMethod: String?, evoLv: Int?){
        pokemonName = name
        self.evoType = evoType
        self.evolutionMethod = evoMethod
        self.evolutionLevel = evoLv
        
    }
}


class GeneralInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    //@IBOutlet weak var evolutionsTable: UITableView!
    //@IBOutlet weak var shinySprite: UIImageView!
    @IBOutlet weak var regularSprite: UIImageView!
    @IBOutlet weak var navbarTitle: UINavigationItem!
    //@IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var type1: UIImageView!
    @IBOutlet weak var genus: UILabel!
    
    @IBOutlet weak var abilityTextView: UITextView!
    //@IBOutlet weak var description: UITextView!
    @IBOutlet weak var type2: UIImageView!
    @IBOutlet weak var evolutionTableView: UITableView!
    
    @IBOutlet weak var hp: UILabel!
    
    @IBOutlet weak var atk: UILabel!
    
    @IBOutlet weak var def: UILabel!
    
    @IBOutlet weak var spAtk: UILabel!
    
    @IBOutlet weak var spDef: UILabel!
    
    @IBOutlet weak var spd: UILabel!
    
    @IBOutlet weak var eggGroup: UILabel!
    
    @IBOutlet weak var evYield: UILabel!
    
    @IBOutlet weak var pokedexEntry: UITextView!
    var Evolutions: [Evolution] = []
    var pokemonArray = [PokemonModel]()
    var evolutionChainURL: String?
    var pokemonData: PokemonModel? = nil
    
    //@IBOutlet weak var evolutionCollectionView: UICollectionView!
    @IBAction func goToMoves(_ sender: Any) {
        performSegue(withIdentifier: "toMoves", sender: self)
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMoves" {
            let destVC = segue.destination as! movesViewController
            destVC.pkmn = self.pokemonData
        }
    }
    
    
    
    func fetchEvolutionObject(json: JSON) -> Evolution{
        var evoTrigger: String? = ""
        var evolutionMethod: String = ""
        var evolutionLevel: Int? = 0
        //print("fetching evolution")
        for (_, details) in json["evolution_details"]{
            evoTrigger = details["trigger"]["name"].stringValue
            if (details["min_level"] != JSON.null){
                print("into min level")
                evolutionLevel = details["min_level"].intValue
            }
            if (details["min_beauty"] != JSON.null){
                print("into min beauty")
                evolutionMethod += ",Achieve minimum beauty value of \(details["min_beauty"].stringValue)"
            }
            if (details["time_of_day"] != ""){
                print("into time of day")
                evolutionMethod += ",\(evoTrigger) at \(details["time_of_day"].stringValue)"
            }
            if (details["gender"] != JSON.null){
                print("into gender")
                evolutionMethod += ",Must be \(details["gender"].stringValue)"
            }
            if (details["relative_physical_stats"] != JSON.null){
                print("into min rel phys stats")
                evolutionMethod += ",Must have \(details["relative_physical_stats"].stringValue)"
            }
            if (details["needs_overworld_rain"] != false){
                print("into rain")
                evolutionMethod += ",Must be raining."
            }
            if (details["turn_upside_down"] != false){
                print("into upside down")
                evolutionMethod += ",Turn game upside down."
            }
            if (details["item"] != JSON.null){
                //print("into min level")
                print("item: \(details["item"])")
                evolutionMethod += ",Use \(details["item"]["name"].stringValue)"
            }
            if (details["known_move_type"] != JSON.null){
                print("into known move type")
                evolutionMethod += ",Must know move of \(details["known_move_type"]["name"].stringValue) type "
            }
            if (details["min_affection"] != JSON.null){
                print("into min affection")
                evolutionMethod += ",Min affection value of \(details["min_affection"].stringValue) "
            }
            if (details["party_type"] != JSON.null){
                print("into party type")
                evolutionMethod += ",Party must have \(details["party_type"]["name"].stringValue) "
            }
            if (details["party_species"] != JSON.null){
                print("into party species")
                evolutionMethod += ",Party must have \(details["party_species"]["name"].stringValue) type "
            }
            if (details["trade_species"] != JSON.null){
                print("into trade species")
                evolutionMethod += ",Trade Species:  \(details["trade_species"]["name"].stringValue) "
            }
            if (details["min_happiness"] != JSON.null){
                print("into min happiness")
                evolutionMethod += ",Min happiness of  \(details["min_happiness"].stringValue) "
            }
            if (details["held_item"] != JSON.null){
                print("into held item")
                evolutionMethod += ",Needs to hold \(details["held_item"]["name"].stringValue) "
            }
            if (details["known_move"] != JSON.null){
                print("into known move")
                evolutionMethod += ",Needs to know \(details["known_move"]["name"].stringValue)"
            }
            if (details["location"] != JSON.null){
                print("into location")
                evolutionMethod += ",Needs to  be at \(details["location"]["name"].stringValue)"
            }
        }
        
        //print("before : \(evolutionMethod)")
        if !evolutionMethod.isEmpty {
            evolutionMethod.remove(at: evolutionMethod.startIndex)
        }
        //print("after : \(evolutionMethod)")
        let result = Evolution(name: json["species"]["name"].stringValue, evoType: evoTrigger, evoMethod: evolutionMethod,evoLv: evolutionLevel)
        //print("\(result.evoType) : \(result.evolutionMethod!) : \(result.evolutionLevel)")
        return result
    }
    
        
    func getPokemonData(){
        var descriptions = [entry]()
        let url = "\(apiURL)pokemon-species/\((pokemonData?.ID)!)/"
        Alamofire.request(url).responseJSON{
            response in
            let json = JSON(data: response.data!)
            //print(json)
            for (_,val) in json["flavor_text_entries"]{
                if val["language"]["name"].stringValue == "en" {
                    descriptions.append(entry(pokedexEntry: val["flavor_text"].stringValue,source: val["version"]["name"].stringValue))
                }
            }
            DispatchQueue.main.async(execute: { 
                self.type1.image = UIImage(named: "\((self.pokemonData?.type1.lowercased())!)")
                self.type2.image = UIImage(named: "\((self.pokemonData?.type2.lowercased())!)")
                self.hp.text = "HP: \((self.pokemonData?.hp)!)"
                self.atk.text = "Atk: \((self.pokemonData?.atk)!)"
                self.def.text = "Def: \((self.pokemonData?.def)!)"
                self.spAtk.text = "Sp.Atk: \((self.pokemonData?.spAtk)!)"
                self.spDef.text = "Sp.Def: \((self.pokemonData?.spDef)!)"
                self.spd.text = "Spd: \((self.pokemonData?.spd)!)"
                self.genus.text = "The \(json["genera"][0]["genus"].stringValue) Pokemon"
                let rand = Int(arc4random_uniform(UInt32(descriptions.count)))
                for abilities in (self.pokemonData?.abilities)! {
                    if abilities.isHidden == false {
                        self.abilityTextView.text = self.abilityTextView.text! + "\n\(abilities.name): \(abilities.effect!)"
                    }
                    else {
                        self.abilityTextView.text = self.abilityTextView.text! + "\n\(abilities.name)(Hidden): \(abilities.effect!)"
                    }
                }
                self.pokedexEntry.text = (self.pokedexEntry.text!) + "\n\(descriptions[rand].pokedexEntry!.replacingOccurrences(of: "\n", with: " ")) \n(Source: \(descriptions[rand].source!))"
                print(self.pokedexEntry.text)
                //print(descriptions.description)
            })
        }
        
    }
    
    func getEvolutionData(){
        let evoChainURL = "\(apiURL)evolution-chain/\((pokemonData?.evolutionID)!)/"
        print(evoChainURL)
        //let evolutionFound: Bool = false
        Alamofire.request(evoChainURL).responseJSON{
            evoResponse in
            
            let evoJson = JSON(evoResponse.result.value!)
            //print("base: \(evoJson["chain"]["species"]["name"])")
            var evolutionFound: Bool = false
            //case 1, this pokemon is the base -> next stage
            
            if (evoJson["chain"]["species"]["name"].stringValue == self.pokemonData?.name.lowercased()){
                //print("this pokemon is the base evolution")
                evolutionFound = true
                //compute the array of pokemon this evolves to
                for (_, value) in evoJson["chain"]["evolves_to"] {
                    //print("evolves into : \(value["name"])")
                    self.Evolutions.append(self.fetchEvolutionObject(json: value))
                }
                
            }
            
            //case 2 -> this pokemon is the second stage -> third stage
            
            for (_, value) in evoJson["chain"]["evolves_to"] {
                if value["species"]["name"].stringValue == self.pokemonData?.name.lowercased() {
                    evolutionFound = true
                    for (_, stage3_value) in value["evolves_to"] {
                        self.Evolutions.append(self.fetchEvolutionObject(json: stage3_value))
                    }
                    // we have found our pokemon, we can loop through its evolutions
                }
            }
            
            // case 3
            if self.Evolutions.count == 0 {
                self.Evolutions.append(Evolution(name: nil, evoType: nil, evoMethod: "\((self.pokemonData?.name)!) does not evolve", evoLv: nil))
                //print("Pokemon does not evolve")
            }
            DispatchQueue.main.async(execute: {
                //print("evo chain id= \(self.pokemonData?.evolutionID)")
                for items in self.Evolutions{
                    for pokemon in self.pokemonArray {
                        if items.pokemonName?.lowercased() == pokemon.name.lowercased(){
                            items.pokemonID = pokemon.ID
                            print("\((items.pokemonID)!): \((items.pokemonName)!)")
                        }
                    }
                }
                //print("#evolutions = \(self.Evolutions.count)")
                if self.Evolutions.count > 0{
                    //print("name dispatch = \(self.Evolutions[0].pokemonName)")
                }
                self.evolutionTableView.reloadData()
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        }
    }

    
    override func viewDidLoad() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        pokedexEntry.layer.borderColor = UIColor.lightGray.cgColor
        pokedexEntry.layer.borderWidth = CGFloat(1.0)
        abilityTextView.layer.borderColor = UIColor.lightGray.cgColor
        abilityTextView.layer.borderWidth = CGFloat(1.0)
        //print("vire loaded")
        super.viewDidLoad()
        //print("\(pokemonData?.ID): \(pokemonData?.name)")
        evolutionTableView.dataSource = self
        evolutionTableView.delegate = self
        //print("getting evo dat")
        //getAbilityEffect()
        getPokemonData()
        getEvolutionData()
        //print("\(pokemonData?.evolutionChainArray.count)")
        //apiCallForData()
        //set image
        
        regularSprite.loadGif(name: "xyspritegif/\(((pokemonData?.name.lowercased())?.replacingOccurrences(of: "-", with: "_"))!)")
        //set nav bar title
        navbarTitle.title = "#\((pokemonData?.ID)!) - \((pokemonData?.name)!)"
        if (pokemonData?.eggMoves.isEmpty)! && (pokemonData?.tmMoves.isEmpty)! && (pokemonData?.lvUpMoves.isEmpty)!{
            //print("loading move data")
            pokemonData?.loadMoves(game: nil)
        }
        // Do any additional setup after loading the view.
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Evolutions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("1")
        let cell = evolutionTableView.dequeueReusableCell(withIdentifier: "evolutionCell", for: indexPath) as! evolutionTableViewCell
        //print("2")
        //cell.currentStage.image = UIImage(named: String(describing: (pokemonData?.ID)!))
        print("\((Evolutions[indexPath.row].pokemonName?.lowercased()))")
        //print("2.5")
        if Evolutions[indexPath.row].pokemonName != nil {
            cell.evolutionImage.loadGif(name: "xyspritegif/\((Evolutions[indexPath.row].pokemonName?.lowercased())!)")
        }
        else {
            cell.evolutionImage.loadGif(name: "xyspritegif/\((pokemonData?.name.lowercased())!)")
        }
        //print("3")
        if (Evolutions[indexPath.row].evoType == "level-up" && Evolutions[indexPath.row].evolutionLevel != 0){
            cell.evolutionDetails.text = "Evolves at Lv. \(String(describing: Evolutions[indexPath.row].evolutionLevel!))"
            //print("4")
            //cell.evolutionImage.image = UIImage(named: String(describing: (Evolutions[indexPath.row].pokemonID)!))
        }
        else if Evolutions[indexPath.row].evoType == nil && Evolutions[indexPath.row].evolutionLevel == nil{
            cell.evolutionDetails.text = "No further Evolution"
            //print("5")
        }
        else {
            if Evolutions[indexPath.row].evolutionMethod! != "" {
                cell.evolutionDetails.text = Evolutions[indexPath.row].evolutionMethod!
            }
            else {
                cell.evolutionDetails.text = Evolutions[indexPath.row].evoType!
            }
            
            //cell.evolutionImage.image = UIImage(named: String(describing: (Evolutions[indexPath.row].pokemonID)!))
            //print("6")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Evolution(s)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
