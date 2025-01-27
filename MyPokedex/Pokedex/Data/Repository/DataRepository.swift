//
//  DataInteractor.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import Foundation
import SwiftData

protocol PokemonRepositoryProtocol {
    func load() throws -> [PokemonDomain]
}

protocol PokemonFavoritedRepositoryProtocol {
    func fetchFavorites() async throws -> [PokemonDomain]
    func add(pokemon: PokemonDomain) async throws
    func delete(pokemonId: UUID) async throws
}

class PokemonDataRepository: @preconcurrency PokemonRepositoryProtocol, PokemonFavoritedRepositoryProtocol {

    private let remoteDataSource: RemoteDataSource
    private let localDataSource: LocalDataSource
    
    static let shared = PokemonDataRepository(remoteDataSource: RemoteDataSource(), localDataSource: LocalDataSource())
    
    init(remoteDataSource: RemoteDataSource, localDataSource: LocalDataSource) {
            self.remoteDataSource = remoteDataSource
            self.localDataSource = localDataSource
    }
    
    func fetchFavorites() async throws -> [PokemonDomain] {
        await self.localDataSource.fetchPokemon().map({$0.fromDataLayerToDomainLayer()})
    }
    
    
    func load() throws -> [PokemonDomain] {
        try self.remoteDataSource.loadData()
    }
    
    func add(pokemon: PokemonDomain) async throws {
        await self.localDataSource.addPokemon(pokemonDB: pokemon.fromDomainLayerToDataLayer())
    }
    
    func delete(pokemonId: UUID) async throws {
        await self.localDataSource.deletePokemonById(pokemonId: pokemonId)
    }
    
}
