//
//  LocalDataSource.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/1/25.
//

import Foundation
import SwiftData

@MainActor
final class LocalDataSource: LocalDataSourceProtocol {
    func fetchPokemon() throws -> [PokemonDomain] {
        let items: [PokemonData]
        do {
            items = try SwiftDataManager.shared.modelContext.fetch(FetchDescriptor<PokemonData>())
        } catch {
            fatalError(error.localizedDescription)
        }
        return try items.map { try PokemonDomain(from: $0) }
    }
    
    func addPokemon(pokemonDB: PokemonData){
        SwiftDataManager.shared.modelContext.insert(pokemonDB)
        do {
            try SwiftDataManager.shared.modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func deletePokemonById(pokemonId: UUID) {
        do {
            let items = try SwiftDataManager.shared.modelContext.fetch(FetchDescriptor<PokemonData>())
            for item in items where item.id == pokemonId {
                SwiftDataManager.shared.modelContext.delete(item)
            }
            try SwiftDataManager.shared.modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}
