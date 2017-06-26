//
//  FirstViewController.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/18/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SQLite
import CoreData

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    //@IBOutlet weak var pokemonTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokemonTable: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var pokemonArray = [PokemonModel]()
    
    var filteredPokemonArray = [PokemonModel]()
    
    var isSearching = false
    
    //pokemonArray.append(PokemonModel("Bulbasaur", 1))
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            print("issearching")
            return filteredPokemonArray.count
        }
        return pokemonArray.count
    }
    
    public func tableView(_ tableView:
        UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell") //pokemonArray[indexPath.row];
        let cell = pokemonTable.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! pokedexTableViewCell
        let pokemon: PokemonModel?
        if isSearching {
            pokemon = filteredPokemonArray[indexPath.row]
        }
        else {
            pokemon = pokemonArray[indexPath.row]
        }
        cell.nameLabel.text = pokemon?.name
        cell.IDLabel.text = String(describing: (pokemon?.ID)!)
        cell.iconImage.image = UIImage(named: String(describing: (pokemon?.ID)!))
        cell.type1Image.image = UIImage(named: (pokemon?.type1.lowercased())!)
        cell.type2Image.image = UIImage(named: (pokemon?.type2.lowercased())!)
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            pokemonTable.reloadData()
        }
        else {
            isSearching = true
            filteredPokemonArray = pokemonArray.filter{$0.name.lowercased().contains((searchBar.text!).lowercased())}
            print("\(searchBar.text!) : \(filteredPokemonArray.count)")
            print("pokemon array filter = \(pokemonArray.filter{$0.name == (searchBar.text!)}.count)")
            pokemonTable.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Do any additional setup after loading the view, typically from a nib.
        //fetchPokemon(ID: 6);
        /*pokemonArray.append(PokemonModel(n: "Bulbasaur", i: 1, t1: <#String#>))
        pokemonArray.append(PokemonModel(n: "Ivysaur", i: 2))
        pokemonArray.append(PokemonModel(n: "Venusaur", i: 3))*/
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        //let realm = try! Realm()
        //print()
        //realm.add(pokemonArray)
        
        //let dbm = DBManager()
        pokemonArray = dbm.queryAllPokemon()
        for pokemon in pokemonArray {
            pokemon.abilities = dbm.generateAbilityData(pokemonID: pokemon.ID)
            //print("\(pokemon.ID): \(pokemon.name))")
            //for abilities in pokemon.abilities{
            //    print("\(abilities.name): \(abilities.effect!)")
            //}
        }
        
        //pokemonArray[0].abilities = dbm.generateAbilityData(pokemonID: pokemonArray[0].ID)
        
        //let moveDict: [String:Move] = dbm.queryAllMoves()
        
        //var levelUpMoves: [LvUpMoveModel] = pokemonArray[0].loadLevelUpMoves(game: nil, moveDict: moveDict)
        //pokemonArray[0].parseDetailsForMove()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = pokemonArray[indexPath.row]
        performSegue(withIdentifier: "generalInfoSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "generalInfoSegue"{
            let destination = segue.destination as? GeneralInfoViewController
            if let indexPath = self.pokemonTable.indexPathForSelectedRow{
                let transferData: PokemonModel
                if isSearching {
                    transferData = filteredPokemonArray[indexPath.row]
                }
                else {
                    transferData = pokemonArray[indexPath.row]
                }
                destination?.pokemonData = transferData
                destination?.pokemonArray = pokemonArray
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

