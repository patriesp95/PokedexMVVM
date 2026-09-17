//
//  PokemonTypeFilter.swift
//  MyPokedex
//

import Foundation

enum PokemonTypeFilter {
    static func apply(_ pokemons: [PokemonUi], selectedTypes: Set<PokemonElementType>) -> [PokemonUi] {
        guard !selectedTypes.isEmpty else { return pokemons }
        return pokemons.filter { pokemon in
            pokemon.type.contains { $0.pokemonElementType.map(selectedTypes.contains) ?? false }
        }
    }

    static func toggling(_ type: PokemonElementType, in selectedTypes: Set<PokemonElementType>) -> Set<PokemonElementType> {
        var result = selectedTypes
        if result.contains(type) {
            result.remove(type)
        } else {
            result.insert(type)
        }
        return result
    }
}
