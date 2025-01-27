//
//  LocalDataSource.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/1/25.
//

import Foundation
import SwiftData

actor LocalDataSource: @preconcurrency LocalDataSourceProtocol {
    func fetchPokemon() -> [PokemonData] {
        do {
            return try SwiftDataManager.shared.modelContext.fetch(FetchDescriptor<PokemonData>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addPokemon(pokemonDB: PokemonData){
        SwiftDataManager.shared.modelContext.insert(pokemonDB)
        do {
            try SwiftDataManager.shared.modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func deletePokemonById(pokemonId:UUID) {
        do {
            let pokeId = pokemonId
            try SwiftDataManager.shared.modelContext.delete(model: PokemonData.self, where: #Predicate<PokemonData>{
                $0.id == pokeId
            })
            try SwiftDataManager.shared.modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}
