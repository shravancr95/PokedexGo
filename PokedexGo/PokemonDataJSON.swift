//
//  PokemonDataJSON.swift
//  PokedexGo
//
//  Created by Radhakrishna Canchi on 5/27/17.
//  Copyright © 2017 Shravan Canchi Radhakrishna. All rights reserved.
//

import Foundation

class PokemonDataJSON: PokemonModel{
    var name: String
    var id: String
    init(name: String, ){
        super.init(n: name, i: id)
    }
}
