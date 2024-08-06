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
    static func imageUrl(id: String) -> URL? {
        guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
        else { return nil}
        return url
    }
}

struct CellIdentifier {
    private init() {}
    static let pokeCollectionViewCell = "PokeCollectionViewCell"
}
