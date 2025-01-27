//
//  ApiManager.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 3/10/24.
//

import SwiftUI
import SwiftData

final class PokemonViewModel: ObservableObject {
    private let repository: PokemonRepositoryProtocol & PokemonFavoritedRepositoryProtocol
    
    @Published var pokemons: [PokemonUi] = []
    
    init(repository: PokemonDataRepository){
        self.repository = repository
        do {
            self.pokemons = try loadPokemons()
        } catch {
            print(error)
        }
    }
    
    func loadPokemons() throws -> [PokemonUi]{
        return try self.repository.load().map({
            let pokemonUi: PokemonUi = $0.fromDomainLayerToUiLayer()
            return pokemonUi
        })
    }
    
    func insertPokemon(pokemon: PokemonUi) async throws {
        try await repository.add(pokemon: pokemon.fromUiLayerToDomainLayer())
    }

}
