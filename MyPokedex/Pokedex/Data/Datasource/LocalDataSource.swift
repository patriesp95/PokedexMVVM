//
//  LocalDataSource.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/1/25.
//

import Foundation
import SwiftData

struct LocalDataSource: @preconcurrency LocalDataSourceProtocol {
    @MainActor func fetchPokemon() -> [PokemonData] {
        do {
            return try SwiftDataManager.shared.modelContext.fetch(FetchDescriptor<PokemonData>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor func addPokemon(pokemonDB: PokemonData){
        SwiftDataManager.shared.modelContext.insert(pokemonDB)
        do {
            try SwiftDataManager.shared.modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    @MainActor func deletePokemon(pokemonDB:PokemonData) {
        do {
            let pokeId = pokemonDB.id
            try SwiftDataManager.shared.modelContext.delete(model: PokemonData.self, where: #Predicate<PokemonData>{
                $0.id == pokeId
            })
            try SwiftDataManager.shared.modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}
