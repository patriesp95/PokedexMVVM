//
//  UiMappers.swift
//  MyPokedex
//
//  Created by patricia.martinez on 17/1/25.
//



extension PokemonUi {
    func fromUiLayerToDomainLayer() -> PokemonDomain {
        return PokemonDomain(name: self.name, type: self.type, imageURL: self.imageURL)
    }
}

extension PokemonUi {
    init (from pokemon: PokemonDomain) {
        self.name = pokemon.name
        self.type = pokemon.type
        self.imageURL = pokemon.imageURL
    }
}
