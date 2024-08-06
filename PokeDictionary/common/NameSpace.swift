//
//  NameSpace.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/5/24.
//

import Foundation

struct PokeAPI {
    private init() {}
        
    static func listUrlString(limit: String, offset: String) -> String {
        return "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
    }
}

struct CellIdentifier {
    private init() {}
    static let pokeCollectionViewCell = "PokeCollectionViewCell"
}
