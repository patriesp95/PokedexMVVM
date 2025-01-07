//
//  FavoritedPokemonViewModel.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import SwiftUI
import SwiftData


final class FavoritedPokemonViewModel: ObservableObject {
    private let repository: PokemonDataRepository
    
    @Published var pokemons: [PokemonData] = []
    
    init(repository: PokemonDataRepository){
        self.repository = repository
    }
    
    @MainActor func deletePokemon(pokemon: PokemonData){
        repository.deletePokemon(pokemon: pokemon)
        self.pokemons = repository.fetchPokemon()
    }
    

}
