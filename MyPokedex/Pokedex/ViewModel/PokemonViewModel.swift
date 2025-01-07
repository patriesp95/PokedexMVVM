//
//  ApiManager.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 3/10/24.
//

import SwiftUI
import SwiftData

final class PokemonViewModel: ObservableObject {
    private let repository: PokemonDataRepository
    
    @Published var pokemons: [Pokemon] = []
    
    init(repository: PokemonDataRepository){
        self.repository = repository
        do {
            self.pokemons = try self.repository.loadData()
        } catch {
            print(error)
        }
    }
    
    @MainActor func insertPokemon(pokemon: Pokemon){
        let pokemonDB = PokemonData(id: pokemon.id, name: pokemon.name, type: pokemon.type, isFavorite: true)
        repository.addPokemon(pokemon: pokemonDB)
    }
    
    @MainActor func deletePokemon(pokemon: PokemonData){
        repository.deletePokemon(pokemon: pokemon)
    }

}
