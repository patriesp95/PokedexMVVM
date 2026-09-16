//
//  DataMappers.swift
//  MyPokedex
//
//  Created by patricia.martinez on 17/1/25.
//

import SwiftUI

extension PokemonData {
    func fromDataLayerToDomainLayer() -> PokemonDomain {
        return PokemonDomain(name: self.name, type: self.type, imageURL: self.imageURL, stats: self.stats)
    }
}

extension PokemonData {
    convenience init(from pokemon: PokemonDomain) {
        self.init(id: pokemon.id, name: pokemon.name, type: pokemon.type, isFavorite: true, imageURL: pokemon.imageURL, stats: pokemon.stats)
    }
}
