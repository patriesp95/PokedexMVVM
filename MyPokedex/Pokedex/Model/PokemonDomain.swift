//
//  PokemonDomain.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 3/10/24.
//

import SwiftUI

struct PokemonList {
    let pokemon: [PokemonDomain]
}


struct PokemonDomain: Codable, Identifiable, Hashable {
    let id = UUID()
    var name: String
    var type: [String]
    var imageURL: URL? = nil
    var stats: PokemonStats? = nil

    enum CodingKeys: String, CodingKey {
        case name, type, imageURL, stats
    }
}
