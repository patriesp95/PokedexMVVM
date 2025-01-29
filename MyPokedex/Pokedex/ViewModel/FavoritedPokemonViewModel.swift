//
//  FavoritedPokemonViewModel.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import SwiftUI
import SwiftData


final class FavoritedPokemonViewModel: ObservableObject {
    private let repository: PokemonFavoritedRepositoryProtocol
    
    @Published var pokemons: [PokemonUi] = []
    
    init(repository: PokemonDataRepository){
        self.repository = repository
    }
    
    @MainActor func deletePokemonById(PokemonId: UUID) async throws {
        try await repository.delete(pokemonId: PokemonId)
        self.pokemons = try await repository.fetchFavorites().map({ pokemonDomain in
            var pokemonUi: PokemonUi =  PokemonUi(from: pokemonDomain)
            return pokemonUi
        })
    }

}
