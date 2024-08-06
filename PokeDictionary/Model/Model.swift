//
//  Model.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/5/24.
//

import Foundation

struct PokeList: Codable {
    let results: [PokeResult]
}
// PokeList에 있는 results
struct PokeResult: Codable {
    let url: String?
}

struct PokeDetail: Codable {
    let name: String?
    let sprites: PokeSprites?
}

struct PokeSprites: Codable {
    let other: PokeOther?
}

struct PokeOther: Codable {
    let officialArtwork: PokeImage?
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct PokeImage: Codable {
    let urlString: String?
    
    enum CodingKeys: String, CodingKey {
        case urlString = "front_default"
    }
}

