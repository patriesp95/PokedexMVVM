//
//  Pokemon.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 3/10/24.
//

import Foundation

struct PokemonList: Codable {
    let pokemon: [Pokemon]
}

struct Pokemon: Codable, Identifiable {
    let id = UUID()
    let name: String
    let type: [String]
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name, type, imageURL
    }
}
