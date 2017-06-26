//
//  movesViewController.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/28/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit

class movesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var methodControl: UISegmentedControl!
    @IBOutlet weak var genPicker: UIPickerView!
    @IBOutlet weak var movesTableView: UITableView!
    
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var games = [String]()
    var gameOfChoice: String = "red-blue"
    //var type: [String] = ["Level up", "Egg moves", "TM/HM"]
    
    var pkmn: PokemonModel?
    var lvlUpMoves = [LvUpMoveModel]()
    var tmMoves = [TMModel]()
    var filteredLvlUpMoves = [LvUpMoveModel]()
    var filteredTMMoves = [TMModel]()
    var filteredEggMoves = [Move]()
    
    
    override func viewDidLoad() {
        genPicker.dataSource = self
        genPicker.delegate = self
        navBarTitle.title = ("\((pkmn?.name)!)'s Moves");
        super.viewDidLoad()
        //let dbm = DBManager()
        //pkmn?.ID = 422
        //gen 1
        //print("\(pkmn?.ID): \(pkmn?.name)")
        //print("\(pkmn?.lvUpMoves.count) : \(pkmn?.tmMoves.count) : \(pkmn?.eggMoves.count)")
        if (pkmn?.ID)! < 152 {
            games = ["red-blue", "yellow", "gold-silver", "crystal", "firered-leafgreen", "ruby-sapphire", "emerald", "diamond-pearl", "platinum", "heartgold-soulsilver", "black-white", "black-2-white-2", "x-y", "omega-ruby-alpha-sapphire"]
        }
        // gen 2
        if (pkmn?.ID)! > 151 && (pkmn?.ID)! < 252 {
            games = ["gold-silver", "crystal", "firered-leafgreen", "ruby-sapphire", "emerald", "diamond-pearl", "platinum", "heartgold-soulsilver", "black-white", "black-2-white-2", "x-y", "omega-ruby-alpha-sapphire"]
        }
        // gen 3
        if (pkmn?.ID)! >= 252 && (pkmn?.ID)! <= 386 {
            games = ["firered-leafgreen", "ruby-sapphire", "emerald", "diamond-pearl", "platinum", "heartgold-soulsilver", "black-white", "black-2-white-2", "x-y", "omega-ruby-alpha-sapphire"]
        }
        //gen 4
        if (pkmn?.ID)! >= 387 && (pkmn?.ID)! <= 493 {
            games = ["diamond-pearl", "platinum", "heartgold-soulsilver", "black-white", "black-2-white-2", "x-y", "omega-ruby-alpha-sapphire"]
        }
        //gen 5
        if (pkmn?.ID)! >= 494 && (pkmn?.ID)! <= 649{
            games = ["black-white", "black-2-white-2", "x-y", "omega-ruby-alpha-sapphire"]
        }
        //gen 6
        if (pkmn?.ID)! >= 650 && (pkmn?.ID)! <= 721{
            games = ["black-white", "black-2-white-2", "x-y", "omega-ruby-alpha-sapphire"]
        }
        tmMoves = (pkmn?.tmMoves)!
        
        lvlUpMoves = (pkmn?.lvUpMoves)!
        //print("level up moves = \(pkmn?.lvUpMoves.count)")
        lvlUpMoves.sort {
            $0.level! < $1.level!
        }

        //genPicker.selectRow(0, inComponent: 0, animated: true)
        
        //gameOfChoice = games[0]
        //print("gameofchoice = \(gameOfChoice)")
        //moveDict = dbm.queryAllMoves()
        //lvlUpMoves = ((pkmn?.loadLevelUpMoves(game: nil, moveDict: moveDict!))!)
        
        filteredLvlUpMoves = lvlUpMoves.filter(){$0.game == gameOfChoice}
        filteredTMMoves = tmMoves.filter(){
            $0.game == gameOfChoice
        }
        filteredEggMoves = (pkmn?.eggMoves.filter(){
            $0.game == gameOfChoice
            })!
        filteredLvlUpMoves.sort{
            $0.level! < $1.level!
        }
        filteredTMMoves.sort{
            $0.TMID! < $1.TMID!
        }

        movesTableView.reloadData()

        
        //movesTableView.reloadData()
        // Do any additional setup after loading the view.
    }

    @IBAction func methodSegControl(_ sender: Any) {
        
        /*switch methodControl.selectedSegmentIndex{
            case 0:
                //print("\(methodControl.selectedSegmentIndex.description)")
            case 1:
                //print("\(methodControl.selectedSegmentIndex.description)")
            case 2:
                //print("\(methodControl.selectedSegmentIndex.description)")
            default:
                break
        }*/
        movesTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if methodControl.selectedSegmentIndex == 0 {
            return filteredLvlUpMoves.count
        }
        else if methodControl.selectedSegmentIndex == 1 {
            return filteredTMMoves.count
        }
        else {
            return filteredEggMoves.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movesTableView.dequeueReusableCell(withIdentifier: "moveCell", for: indexPath) as! moveTableViewCell
        if methodControl.selectedSegmentIndex == 1 {
            if (filteredTMMoves[indexPath.row].TMNum! < 10){
                cell.levelLabel.text = "\(filteredTMMoves[indexPath.row].machineType!)0\(String(describing: filteredTMMoves[indexPath.row].TMNum!))"
            }
            else {
                cell.levelLabel.text = "\(filteredTMMoves[indexPath.row].machineType!)\(String(describing: filteredTMMoves[indexPath.row].TMNum!))"
            }
            //cell.gameLabel.text = filteredTMMoves[indexPath.row].game!
            cell.moveLabel.text = filteredTMMoves[indexPath.row].move?.name
            if filteredTMMoves[indexPath.row].move?.power == 0 {
                cell.attackLabel.text = "Att.: -"
            }
            else {
                cell.attackLabel.text = "Att. : " + String(describing: (filteredTMMoves[indexPath.row].move?.power!)!)
            }
            cell.accuracyLabel.text = "Acc. : " + String(describing: (filteredTMMoves[indexPath.row].move?.accuracy!)!)
            
            cell.ppLabel.text = "PP: " + String(describing: (filteredTMMoves[indexPath.row].move?.pp!)!)
            
            cell.moveEffectTextView.text = String(describing: (filteredTMMoves[indexPath.row].move?.effect!)!)
            
            cell.typeImageView.image = UIImage(named: (filteredTMMoves[indexPath.row].move?.type?.lowercased())!)
            

        }
        else if methodControl.selectedSegmentIndex == 0{
            //cell.gameLabel.text = filteredLvlUpMoves[indexPath.row].game!
            cell.levelLabel.text = "Lv. \(String(describing: filteredLvlUpMoves[indexPath.row].level!))"
            cell.moveLabel.text = filteredLvlUpMoves[indexPath.row].move?.name
            
            cell.moveLabel.text = filteredLvlUpMoves[indexPath.row].move?.name
            if filteredLvlUpMoves[indexPath.row].move?.power == 0 {
                cell.attackLabel.text = "Att.: -"
            }
            else {
                cell.attackLabel.text = "Att. : " + String(describing: (filteredLvlUpMoves[indexPath.row].move?.power!)!)
            }
            cell.accuracyLabel.text = "Acc. : " + String(describing: (filteredLvlUpMoves[indexPath.row].move?.accuracy!)!)
            
            cell.ppLabel.text = "PP: " + String(describing: (filteredLvlUpMoves[indexPath.row].move?.pp!)!)
            
            cell.moveEffectTextView.text = String(describing: (filteredLvlUpMoves[indexPath.row].move?.effect!)!)
            
            cell.typeImageView.image = UIImage(named: (filteredLvlUpMoves[indexPath.row].move?.type?.lowercased())!)
        }
        else {
            //cell.gameLabel.text = filteredEggMoves[indexPath.row].game!
            cell.levelLabel.text = "Egg"
            cell.moveLabel.text = filteredEggMoves[indexPath.row].name
            //filteredEggMoves[indexPath.row]
            if filteredEggMoves[indexPath.row].power == 0 {
                cell.attackLabel.text = "Att.: -"
            }
            else {
                cell.attackLabel.text = "Att. : " + String(describing: (filteredEggMoves[indexPath.row].power!))
            }
            cell.accuracyLabel.text = "Acc. : " + String(describing: (filteredEggMoves[indexPath.row].accuracy!))
            
            cell.ppLabel.text = "PP: " + String(describing: (filteredEggMoves[indexPath.row].pp!))
            
            cell.moveEffectTextView.text = String(describing: (filteredEggMoves[indexPath.row].effect!))
            
            cell.typeImageView.image = UIImage(named: (filteredEggMoves[indexPath.row].type?.lowercased())!)
        }
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return games.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return games[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gameOfChoice = games[row]
        //print("game of choice = \(gameOfChoice)")
        filteredLvlUpMoves = lvlUpMoves.filter(){$0.game == gameOfChoice}
        filteredTMMoves = tmMoves.filter(){
            $0.game == gameOfChoice
        }
        filteredEggMoves = (pkmn?.eggMoves.filter(){
            $0.game == gameOfChoice
        })!
        filteredLvlUpMoves.sort{
            $0.level! < $1.level!
        }
        filteredTMMoves.sort{
            $0.TMID! < $1.TMID!
        }
        
        //print(filteredLvlUpMoves.count)
        movesTableView.reloadData()
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
