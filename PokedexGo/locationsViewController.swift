//
//  locationsViewController.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 6/9/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class filteredData{
    var location: String?
    var version: String?
    var min_level: Int?
    var max_level: Int?
    var method: String?
    var condition: String?
    var maxChance: Int?
    init(location: String?, version: String?, min_level: Int?, max_level: Int?, method: String?, condition: String?, maxChance: Int?){
        self.location = location
        self.version = version
        self.maxChance = maxChance
        self.min_level = min_level
        self.max_level = max_level
        self.method = method
        self.condition = condition
    }
}

class locationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pokemonImage: UIImageView!
    
    @IBOutlet weak var generationsSegControl: UISegmentedControl!
    @IBOutlet weak var locationsTableView: UITableView!
    var pokemonData: PokemonModel?
    var locationList = [EncountersData]()
    var simplifiedLocationList = [filteredData]()
    var versionNames = ["red", "blue", "yellow", "gold", "silver", "crystal", "ruby", "sapphire", "emerald", "firered", "leafgreen", "diamond", "pearl", "platinum", "heartgold", "soulsilver", "black", "white", "black-2", "white-2", "x", "y", "omega-ruby", "alpha-sapphire"]
    
    struct Sections{
        var version: String?
        var encounterData: [filteredData]?
    }
    
    var sectionArray = [Sections]()
    
    
    //var sectionArray = [Sections(version: "red", encounterData: simplifiedLocationList.filter(){$0.version == "red"})]
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func generationSegController(_ sender: Any) {
        print("reload for \(generationsSegControl.selectedSegmentIndex)")
        if self.generationsSegControl.selectedSegmentIndex == 0 {
            self.sectionArray = [Sections(version: "Red", encounterData: self.simplifiedLocationList.filter{$0.version == "red"}), Sections(version: "Blue", encounterData: self.simplifiedLocationList.filter{$0.version == "blue"}), Sections(version: "Yellow", encounterData: self.simplifiedLocationList.filter{$0.version == "yellow"})]
        }
        else if self.generationsSegControl.selectedSegmentIndex == 1 {
            self.sectionArray = [Sections(version: "Gold", encounterData: self.simplifiedLocationList.filter{$0.version == "gold"}), Sections(version: "Silver", encounterData: self.simplifiedLocationList.filter{$0.version == "silver"}), Sections(version: "Crystal", encounterData: self.simplifiedLocationList.filter{$0.version == "crystal"})]
        }
        else if self.generationsSegControl.selectedSegmentIndex == 2 {
            self.sectionArray = [Sections(version: "Ruby", encounterData: self.simplifiedLocationList.filter{$0.version == "ruby"}), Sections(version: "Sapphire", encounterData: self.simplifiedLocationList.filter{$0.version == "sapphire"}), Sections(version: "Firered", encounterData: self.simplifiedLocationList.filter{$0.version == "firered"}), Sections(version: "Leafgreen", encounterData: self.simplifiedLocationList.filter{$0.version == "leafgreen"}), Sections(version: "Emerald", encounterData: self.simplifiedLocationList.filter{$0.version == "emerald"})]
        }
        else if self.generationsSegControl.selectedSegmentIndex == 3 {
            self.sectionArray = [Sections(version: "Diamond", encounterData: self.simplifiedLocationList.filter{$0.version == "diamond"}), Sections(version: "Pearl", encounterData: self.simplifiedLocationList.filter{$0.version == "pearl"}), Sections(version: "Platinum", encounterData: self.simplifiedLocationList.filter{$0.version == "platinum"}), Sections(version: "Heartgold", encounterData: self.simplifiedLocationList.filter{$0.version == "heartgold"}), Sections(version: "Soulsilver", encounterData: self.simplifiedLocationList.filter{$0.version == "soulsilver"})]
        }

        else if self.generationsSegControl.selectedSegmentIndex == 4 {
            self.sectionArray = [Sections(version: "Black", encounterData: self.simplifiedLocationList.filter{$0.version == "black"}), Sections(version: "White", encounterData: self.simplifiedLocationList.filter{$0.version == "white"}), Sections(version: "Black 2", encounterData: self.simplifiedLocationList.filter{$0.version == "black-2"}), Sections(version: "White 2", encounterData: self.simplifiedLocationList.filter{$0.version == "white-2"})]
        }
        else if self.generationsSegControl.selectedSegmentIndex == 5 {
            self.sectionArray = [Sections(version: "X", encounterData: self.simplifiedLocationList.filter{$0.version == "x"}), Sections(version: "Y", encounterData: self.simplifiedLocationList.filter{$0.version == "y"}), Sections(version: "Omega Ruby", encounterData: self.simplifiedLocationList.filter{$0.version == "omega-ruby"}), Sections(version: "Alpha Sapphire", encounterData: self.simplifiedLocationList.filter{$0.version == "alpha-sapphire"})]
        }else{}
        
        locationsTableView.reloadData()
    }
    
    
    func loadLocationJSON(){
        let url = "\(apiURL)pokemon/\((pokemonData?.ID)!)/encounters"
        var locationArea: String?
        
        Alamofire.request(url).responseJSON{
            response in
            let json = JSON(data: response.data!)
            //start location
            for (_, location) in json{
                //initial encounterData
                var encounterData = EncountersData(location: location["location_area"]["name"].stringValue)
                //print((encounterData.location)!)
                //startversionDetails
                for (versionDetailsKey, versionDetailsValue) in location["version_details"]{
                    var versionDetails = VersionDetail(version: versionDetailsValue["version"]["name"].stringValue, maxChance: versionDetailsValue["max_chance"].intValue)
                    //print("\((versionDetails.version)!) \((versionDetails.maxChance)!)%")
                    for (encounterDetailsKey, encounterDetailsValue) in versionDetailsValue["encounter_details"]{
                        var encounterDetails = EncounterDetails(minLv: encounterDetailsValue["min_level"].intValue, maxLv: encounterDetailsValue["max_level"].intValue, method: encounterDetailsValue["method"]["name"].stringValue, chance: encounterDetailsValue["chance"].intValue)
                        for (conditionKey, conditionValue) in encounterDetailsValue["condition_values"]{
                            encounterDetails.conditions.append(conditionValue["name"].stringValue)
                        }
                        versionDetails.encounterDetails.append(encounterDetails)
                    }
                    //end encounterDetails
                    encounterData.versionDetails.append(versionDetails)
                }
                //end versionDetails
                self.locationList.append(encounterData)
                DispatchQueue.main.async {
                    self.simplifiedLocationList = self.dataSimplify(location: self.locationList)
                    if self.generationsSegControl.selectedSegmentIndex == 0 {
                        self.sectionArray = [Sections(version: "Red", encounterData: self.simplifiedLocationList.filter{$0.version == "red"}), Sections(version: "Blue", encounterData: self.simplifiedLocationList.filter{$0.version == "blue"}), Sections(version: "Yellow", encounterData: self.simplifiedLocationList.filter{$0.version == "yellow"})]
                    }
                    else if self.generationsSegControl.selectedSegmentIndex == 1 {
                        self.sectionArray = [Sections(version: "Gold", encounterData: self.simplifiedLocationList.filter{$0.version == "gold"}), Sections(version: "Silver", encounterData: self.simplifiedLocationList.filter{$0.version == "silver"}), Sections(version: "Crystal", encounterData: self.simplifiedLocationList.filter{$0.version == "crystal"})]
                    }
                    else if self.generationsSegControl.selectedSegmentIndex == 2 {
                        self.sectionArray = [Sections(version: "Ruby", encounterData: self.simplifiedLocationList.filter{$0.version == "ruby"}), Sections(version: "Sapphire", encounterData: self.simplifiedLocationList.filter{$0.version == "sapphire"}), Sections(version: "Firered", encounterData: self.simplifiedLocationList.filter{$0.version == "firered"}), Sections(version: "Leafgreen", encounterData: self.simplifiedLocationList.filter{$0.version == "leafgreen"}), Sections(version: "Emerald", encounterData: self.simplifiedLocationList.filter{$0.version == "emerald"})]
                    }
                    else if self.generationsSegControl.selectedSegmentIndex == 3 {
                        self.sectionArray = [Sections(version: "Diamond", encounterData: self.simplifiedLocationList.filter{$0.version == "diamond"}), Sections(version: "Pearl", encounterData: self.simplifiedLocationList.filter{$0.version == "pearl"}), Sections(version: "Platinum", encounterData: self.simplifiedLocationList.filter{$0.version == "platinum"}), Sections(version: "Heartgold", encounterData: self.simplifiedLocationList.filter{$0.version == "heartgold"}), Sections(version: "Soulsilver", encounterData: self.simplifiedLocationList.filter{$0.version == "soulsilver"})]
                    }
                        
                    else if self.generationsSegControl.selectedSegmentIndex == 4 {
                        self.sectionArray = [Sections(version: "Black", encounterData: self.simplifiedLocationList.filter{$0.version == "black"}), Sections(version: "White", encounterData: self.simplifiedLocationList.filter{$0.version == "white"}), Sections(version: "Black 2", encounterData: self.simplifiedLocationList.filter{$0.version == "black-2"}), Sections(version: "White 2", encounterData: self.simplifiedLocationList.filter{$0.version == "white-2"})]
                    }
                    else if self.generationsSegControl.selectedSegmentIndex == 5 {
                        self.sectionArray = [Sections(version: "X", encounterData: self.simplifiedLocationList.filter{$0.version == "x"}), Sections(version: "Y", encounterData: self.simplifiedLocationList.filter{$0.version == "y"}), Sections(version: "Omega Ruby", encounterData: self.simplifiedLocationList.filter{$0.version == "omega-ruby"}), Sections(version: "Alpha Sapphire", encounterData: self.simplifiedLocationList.filter{$0.version == "alpha-sapphire"})]
                    }else{}
                    print("Num sections: \(self.simplifiedLocationList.count)")
                    self.locationsTableView.reloadData()
                }
            }
        }
    }
    
    func dataSimplify(location: [EncountersData]) -> [filteredData]{
        var result: [filteredData] = []
        //print("after db query = \(result.count)")
        var locationArea: String?
        var game: String?
        var maxChance: Int?
        var method: String?
        var conditions: String?
        var minLv: Int?
        var maxLv: Int?
        for data in location{
            //var location = data.location
            locationArea = data.location
            for versions in data.versionDetails {
                maxChance = versions.maxChance
                game = versions.version
                minLv = fetchMinLevel(encounters: versions.encounterDetails)
                maxLv = fetchMaxLevel(encounters: versions.encounterDetails)
                var newData:filteredData = filteredData(location: locationArea, version: game, min_level: minLv, max_level: maxLv, method: nil, condition: nil, maxChance: maxChance)
                //print("\((newData.version)!) : \((newData.location)!) : Lv. \(String(describing: newData.min_level))-\(String(describing: newData.max_level))")
                //print("\((newData.method)!) : \((newData.condition)!)")
                
                var methodCollection: Set<String> = []
                for encounters in versions.encounterDetails {
                    if (!(methodCollection.contains(encounters.method!))){
                        var totalChance: Int = 0;
                        newData.method = encounters.method
                        methodCollection.insert(encounters.method!)
                        newData.condition = parseConditionText(condition: encounters.conditions)
                        for items in versions.encounterDetails{
                            if items.method == encounters.method {
                                totalChance += items.chance!
                            }
                        }
                        newData.maxChance = totalChance
                        //print ("\((newData.method)!) \((newData.condition)!) : \((totalChance))%")
                        //print("")
                        result.append(newData)
                    }
                    
                    //print ("\((newData.method)!) and \((newData.condition)!)")
                    //print("")
                }
            }
        }
        return result
    }
    
    func fetchMinLevel(encounters: [EncounterDetails]) -> Int{
        var min: Int = 101
        //print("\(encounters.count)")
        for items in encounters {
            //print("\(items.method)")
            
            //print("\(items.minLv) - \(items.maxLv)")
            //print("# of conditions: \(items.conditions.count)")
            if items.minLv! < min {
                //print("\(items.method)")
               // print("\(items.minLv) - \(items.maxLv)")
                min = items.minLv!
            }
        }
        return min
    }
    
    func fetchMaxLevel(encounters: [EncounterDetails]) -> Int{
        var max: Int = -1
        //print("init max = -1")
        for items in encounters {
            if items.maxLv! > max {
                //print("updating max -> \(String(describing: items.maxLv))")
                max = items.maxLv!
            }
        }
        return max
    }

    func setPokemonImage() {
        if pokemonData?.ID == 29 {
            pokemonImage.loadGif(name: "xyspritegif/nidoran_f")
        }
        else if pokemonData?.ID == 32 {
            pokemonImage.loadGif(name: "xyspritegif/nidoran_m")
        }
        else {
            pokemonImage.loadGif(name: "xyspritegif/\((pokemonData?.name.lowercased())!)")
        }
    }
    
    override func viewDidLoad() {
        setPokemonImage()
        simplifiedLocationList = dbm.querySpecialPokemonLocation(id: (pokemonData?.ID)!)
        if self.generationsSegControl.selectedSegmentIndex == 0 {
            self.sectionArray = [Sections(version: "Red", encounterData: self.simplifiedLocationList.filter{$0.version == "red"}), Sections(version: "Blue", encounterData: self.simplifiedLocationList.filter{$0.version == "blue"}), Sections(version: "Yellow", encounterData: self.simplifiedLocationList.filter{$0.version == "yellow"})]
        }
        else if self.generationsSegControl.selectedSegmentIndex == 1 {
            self.sectionArray = [Sections(version: "Gold", encounterData: self.simplifiedLocationList.filter{$0.version == "gold"}), Sections(version: "Silver", encounterData: self.simplifiedLocationList.filter{$0.version == "silver"}), Sections(version: "Crystal", encounterData: self.simplifiedLocationList.filter{$0.version == "crystal"})]
        }
        else if self.generationsSegControl.selectedSegmentIndex == 2 {
            self.sectionArray = [Sections(version: "Ruby", encounterData: self.simplifiedLocationList.filter{$0.version == "ruby"}), Sections(version: "Sapphire", encounterData: self.simplifiedLocationList.filter{$0.version == "sapphire"}), Sections(version: "Firered", encounterData: self.simplifiedLocationList.filter{$0.version == "firered"}), Sections(version: "Leafgreen", encounterData: self.simplifiedLocationList.filter{$0.version == "leafgreen"}), Sections(version: "Emerald", encounterData: self.simplifiedLocationList.filter{$0.version == "emerald"})]
        }
        else if self.generationsSegControl.selectedSegmentIndex == 3 {
            self.sectionArray = [Sections(version: "Diamond", encounterData: self.simplifiedLocationList.filter{$0.version == "diamond"}), Sections(version: "Pearl", encounterData: self.simplifiedLocationList.filter{$0.version == "pearl"}), Sections(version: "Platinum", encounterData: self.simplifiedLocationList.filter{$0.version == "platinum"}), Sections(version: "Heartgold", encounterData: self.simplifiedLocationList.filter{$0.version == "heartgold"}), Sections(version: "Soulsilver", encounterData: self.simplifiedLocationList.filter{$0.version == "soulsilver"})]
        }
            
        else if self.generationsSegControl.selectedSegmentIndex == 4 {
            self.sectionArray = [Sections(version: "Black", encounterData: self.simplifiedLocationList.filter{$0.version == "black"}), Sections(version: "White", encounterData: self.simplifiedLocationList.filter{$0.version == "white"}), Sections(version: "Black 2", encounterData: self.simplifiedLocationList.filter{$0.version == "black-2"}), Sections(version: "White 2", encounterData: self.simplifiedLocationList.filter{$0.version == "white-2"})]
        }
        else if self.generationsSegControl.selectedSegmentIndex == 5 {
            self.sectionArray = [Sections(version: "X", encounterData: self.simplifiedLocationList.filter{$0.version == "x"}), Sections(version: "Y", encounterData: self.simplifiedLocationList.filter{$0.version == "y"}), Sections(version: "Omega Ruby", encounterData: self.simplifiedLocationList.filter{$0.version == "omega-ruby"}), Sections(version: "Alpha Sapphire", encounterData: self.simplifiedLocationList.filter{$0.version == "alpha-sapphire"})]
        }else{}
        //locationsTableView.reloadData()
        super.viewDidLoad()
        print("\(simplifiedLocationList.count)")
        loadLocationJSON()
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section].version
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prettyConditionText(str: String) -> String{
        if (str == "swarm-yes"){
            return "while swarming"
        }
        else if (str == "swarm-no"){
            return "while not swarming"
        }
        else if (str == "time-morning"){
            return "during morning time"
        }
        else if (str == "time-day"){
            return "during daytime"
        }
        else if (str == "time-night"){
            return "during nighttime"
        }
        else if (str == "radar-off"){
            return "with pokeradar off"
        }
        else if (str == "radar-on"){
            return "with pokeradar on"
        }
        else if (str == "slot2-none"){
            return "with no game in slot 2"
        }
        else if (str == "slot2-ruby"){
            return "with ruby in gba slot"
        }
        else if (str == "slot2-sapphire"){
            return "with sapphire in gba slot"
        }
        else if (str == "slot2-emerald"){
            return "with emerald in gba slot"
        }
        else if (str == "slot2-firered"){
            return "with firered in gba slot"
        }
        else if (str == "slot2-leafgreen"){
            return "with leafgreen in slot 2"
        }
        else if (str == "radio-off"){
            return "while pokegear radio is off"
        }
        else if (str == "radio-hoenn"){
            return "with pokegear radio set to hoenn sound"
        }
        else if (str == "radio-sinnoh"){
            return "with pokegear radio set to sinnoh sound"
        }
        else if (str == "season-spring"){
            return "only in spring"
        }
        else if (str == "season-summer"){
            return "only in summer"
        }
        else if (str == "season-autumn"){
            return "only in autumn"
        }
        else if (str == "season-winter"){
            return "only in winter"
        }
        else {
            return ""
        }
    }
    
    func parseConditionText(condition: [String]) -> String{
        //prettify output
        var result : String = ""
        for index in 0..<condition.count {
            if (index == condition.count - 1){
                if (condition.count > 1){
                    result = result + "and \(prettyConditionText(str: condition[index]))"
                }
                else {
                    result = result + "\(prettyConditionText(str: condition[index]))"
                }
            }
            else {
                if index > 1 {
                    result = result + ", \(prettyConditionText(str: condition[index])) "
                }
                else{
                    result = result + " \(prettyConditionText(str: condition[index])) "
                }
            }
        }
        return result
    }
    
    func prettyLocation(str: String)->String{
        //var result: String?
        //print("prettylocation")
        //return str.replacingOccurrences(of: "-", with: " ")
        return str.replacingOccurrences(of: "-", with: " ").replacingOccurrences(of: "area", with: "").replacingOccurrences(of: "kanto", with: "").replacingOccurrences(of: "johto", with: "").replacingOccurrences(of: "hoenn", with: "").replacingOccurrences(of: "sinnoh", with: "").replacingOccurrences(of: "kalos", with: "").replacingOccurrences(of: "unova", with: "")
        
        //return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationsTableView.dequeueReusableCell(withIdentifier: "locationCell") as! LocationsTableViewCell
        let encounter = sectionArray[indexPath.section].encounterData?[indexPath.row]
        cell.locationAreaLabel.text = "\(prettyLocation(str: (encounter?.location)!))"
        //cell.versionLabel.text = "Version: \((encounter?.version!)!))"

        if (simplifiedLocationList[indexPath.row].min_level == simplifiedLocationList[indexPath.row].max_level){
            cell.levelRangeLabel.text = "Lv. \((encounter?.max_level!)!)"
        }
        else{
            cell.levelRangeLabel.text = "Lv. \((encounter?.min_level!)!) - \((encounter?.max_level!)!)"
        }
        if simplifiedLocationList[indexPath.row].condition == "[]" {
            cell.methodLabel.text = "Method: \(((encounter?.method)!)!)"
        }
        else{
            if simplifiedLocationList[indexPath.row].condition == "" {
                cell.methodLabel.text = "Method: \(((encounter?.method)!)!) \((encounter?.condition)!)"
            }
            else{
                cell.methodLabel.text = "Method: \(((encounter?.method)!)!) \(((encounter?.condition)!)!)"
            }
        }
        cell.chanceLabel.text = "Chance: \((encounter?.maxChance)!)%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray[section].encounterData!.count
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
