//
//  Constants.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/18/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import Foundation

let apiURL = "http://pokeapi.co/api/v2/"

let dbm = DBManager()

let moveDict: [String:Move] = dbm.queryAllMoves()
