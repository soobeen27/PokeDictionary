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
    let id: Int?
    let name: String?
    let height: Int?
    let weight: Int?
    let types: [PokeTypes]?
//    let sprites: PokeSprites?
}

struct PokeTypes: Codable {
    let type: PokeType?
}

struct PokeType: Codable {
    let name: String?
}


//
//struct PokeSprites: Codable {
//    let other: PokeOther?
//}
//
//struct PokeOther: Codable {
//    let officialArtwork: PokeImage?
//    
//    enum CodingKeys: String, CodingKey {
//        case officialArtwork = "official-artwork"
//    }
//}
//
//struct PokeImage: Codable {
//    let urlString: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case urlString = "front_default"
//    }
//}

