//
//  SecondViewController.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/18/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import UIKit
import SQLite
import CoreData

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressTable: UITableView!
    var managedObjectContext: NSManagedObjectContext!
    var pokedex = [PokemonModel]()
    var pokedexProgress = [PokemonDataModel]()
    var pokedexProgressFilter = [PokemonDataModel]()
    var isSearching:Bool = false
    //let dbm = DBManager()
    override func viewDidLoad() {
        //try dbm.run()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        pokedex = dbm.queryAllPokemon()
        //deleteAllRecords()
        //loadDataToDB(start: 0, finish: 2)
        loadDataToDB(start: 0, finish: 717)
        loadDataIntoTable()
        //dbm.createProgressTable()
        //print("\(progress[0].ID):\(progress[0].name)")
        //progressTable.reloadData()
    }
    
    func loadDataToDB(start: Int, finish: Int){
        for index in start...finish{
            loadRecord(data: pokedex[index])
        }
    }
    
    func loadDataIntoTable(){
        let request: NSFetchRequest<PokemonDataModel> = PokemonDataModel.fetchRequest()
        do {
            pokedexProgress = try managedObjectContext.fetch(request)
            self.progressTable.reloadData()
        }
        catch{
            print("could not load data from db \(error.localizedDescription)")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            progressTable.reloadData()
        }
        else {
            isSearching = true
            pokedexProgressFilter = pokedexProgress.filter{($0.name?.lowercased().contains((searchBar.text!).lowercased()))!}
            //print("\(searchBar.text!) : \(filteredPokemonArray.count)")
            //print("pokemon array filter = \(pokemonArray.filter{$0.name == (searchBar.text!)}.count)")
            progressTable.reloadData()
        }

    }
    
    func loadRecord(data: PokemonModel){
        
        let exists: Bool = doesExistInDB(pokemonID: data.ID)
        
        do{
            if(exists == false){
                let pokemonItem = PokemonDataModel(context: managedObjectContext)
                pokemonItem.name = data.name
                pokemonItem.id = Int32(data.ID)
                pokemonItem.type1 = data.type1
                pokemonItem.type2 = data.type2
                pokemonItem.caught = false
                try self.managedObjectContext.save()
            }
        }
        catch{
            print("Could not upload, error: \(error)")
        }

    }
    
    func deleteRecord(pokemonID: Int){
        //let request: NSFetchRequest<PokemonDataModel> = PokemonDataModel.fetchRequest()
    }
    
    func deleteAllRecords(){
        //let appDel = UIApplication.shared.delegate as! AppDelegate
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonDataModel")
        print("size of fetch: \(fetch.fetchBatchSize)")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do{
            try managedObjectContext.execute(request)
            print("Successfully deleted everything.")
        }
        catch{
            print("unable to delete \(error.localizedDescription)")
        }
        
        do{
           try self.managedObjectContext.save()
        }
        catch{
            print("Unable to delete \(error.localizedDescription)")
        }
    }
    
    func doesExistInDB(pokemonID: Int) -> Bool{
        //let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonDataModel")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonDataModel")
        fetchRequest.predicate = NSPredicate(format: "id==\(pokemonID)")
        fetchRequest.fetchLimit = 1
        do{
            let count = try managedObjectContext.count(for: fetchRequest)
            if count == 0 {
                //print("Pokemon with ID \(pokemonID) does not exist so we can add")
                return false
            }
            /*else{
                print("Pokemon with ID \(pokemonID) exists so don't add")
                return true
            }*/
        }
        catch{
            print("Error in check: \(error.localizedDescription)")
        }
        //print("Pokemon with ID \(pokemonID) exists so don't add")
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            print("issearching")
            return pokedexProgressFilter.count
        }
        return pokedexProgress.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = progressTable.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath) as! progressDexTableViewCell
        let tableItem: PokemonDataModel!
        if !isSearching {
            tableItem = pokedexProgress[indexPath.row]
        }
        else {
            tableItem = pokedexProgressFilter[indexPath.row]
        }
        //let tableItem = pokedexProgress[indexPath.row]
        cell.type1Image.image = UIImage(named: (tableItem.type1?.lowercased())!)
        cell.type2Image.image = UIImage(named: (tableItem.type2?.lowercased())!)
        cell.pokemonInfoLabel.text = "\((tableItem.id))  \((tableItem.name)!)"
        cell.pkmnIcon.image = UIImage(named: String(Int(tableItem.id)))
        if tableItem.caught == false{
            cell.pokeballImage.image = nil
        }
        else{
            cell.pokeballImage.image = UIImage(named: "pokeball")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let caught = UITableViewRowAction(style: .normal, title: "Captured!"){
            action, index in
            if self.isSearching {
                self.pokedexProgressFilter[indexPath.row].caught = true
                self.updateCaptureStatus(id: Int(self.pokedexProgressFilter[indexPath.row].id), captureStatus: true)
            }
            else {
                self.pokedexProgress[indexPath.row].caught = true
                self.updateCaptureStatus(id: Int(self.pokedexProgress[indexPath.row].id), captureStatus: true)
            }
            tableView.reloadData()
        }
        caught.backgroundColor = UIColor.red
        let notCaught = UITableViewRowAction(style: .normal, title: "Not caught"){
            action, index in
            if self.isSearching {
                self.pokedexProgressFilter[indexPath.row].caught = true
                self.updateCaptureStatus(id: Int(self.pokedexProgressFilter[indexPath.row].id), captureStatus: true)
            }
            else {
                self.pokedexProgress[indexPath.row].caught = false
                self.updateCaptureStatus(id: Int(self.pokedexProgress[indexPath.row].id), captureStatus: false)
            }
            tableView.reloadData()
        }
        notCaught.backgroundColor = UIColor.gray
        return [caught, notCaught]
    }
    
    func updateCaptureStatus(id: Int, captureStatus: Bool){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonDataModel")
        
        fetchRequest.predicate = NSPredicate(format: "id==\(id)")
        do{
            //print("Setting the capture status of #\(id) to \(captureStatus)")
            if let fetchResult = try managedObjectContext.execute(fetchRequest) as? [NSManagedObject]{
                let pkmnObj = fetchResult[0]
                print("Set the capture status of #\(id) to \(captureStatus)")
                pkmnObj.setValue(captureStatus, forKey: "caught")
            }
        }
        catch{
            print("Error: \(error.localizedDescription)")
        }
        do{
            try managedObjectContext.save()
        }
        catch{
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "locationsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationsSegue" {
            let destinationVC = segue.destination as! locationsViewController
            if let indexPath = progressTable.indexPathForSelectedRow {
                print("transferring dat: \(pokedex[indexPath.row])")
                destinationVC.pokemonData = pokedex[indexPath.row]
                print("fin transfer")
            }
        }
    }
}
