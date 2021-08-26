//
//  RawPokemonListResult.swift
//  PokemonEncyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import Foundation

struct RawPokemonListResult: Codable {
    
    let count: Int
    let next: String
    let pokemons: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decode(Int.self, forKey: .count)
        pokemons = try values.decode([Pokemon].self, forKey: .results)
        next = try values.decode(String.self, forKey: .next)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(next, forKey: .next)
        try container.encode(pokemons, forKey: .results)
    }
}




























// MARK: - Sprites
  struct Sprites: Codable {
    let other: Other
}
  
// MARK: - Other
  struct Other: Codable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// MARK: - OfficialArtwork
  struct OfficialArtwork: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Ability
  struct Ability: Codable {
    let ability: Species

    enum CodingKeys: String, CodingKey {
        case ability
    }
}

// MARK: - Species
  struct Species: Codable {
    let name: String
//    let url: String
    
}


extension NSError {
     
    static func getWith(description : String) -> Error{
        return  NSError(domain: "localError", code: 99999, userInfo: [NSLocalizedDescriptionKey: description])
    }
}

extension String {
    var possibleURL : URL?{
        return  URL(string: self)
    }
}
