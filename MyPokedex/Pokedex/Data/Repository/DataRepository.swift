//
//  DataInteractor.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import Foundation
import SwiftData

@MainActor
protocol PokemonRepositoryProtocol {
    func load() throws -> [PokemonDomain]
}

@MainActor
protocol PokemonFavoritedRepositoryProtocol {
    func fetchFavorites() async throws -> [PokemonDomain]
    func add(pokemon: PokemonDomain) async throws
    func delete(pokemonId: UUID) async throws
}

@MainActor
class PokemonDataRepository: PokemonRepositoryProtocol, PokemonFavoritedRepositoryProtocol {

    private let remoteDataSource: RemoteDataSource
    private let localDataSource: LocalDataSource
    
    static let shared = PokemonDataRepository(remoteDataSource: RemoteDataSource(), localDataSource: LocalDataSource())
    
    init(remoteDataSource: RemoteDataSource, localDataSource: LocalDataSource) {
            self.remoteDataSource = remoteDataSource
            self.localDataSource = localDataSource
    }
    
    func fetchFavorites() async throws -> [PokemonDomain] {
        try self.localDataSource.fetchPokemon()
    }
    
    
    func load() throws -> [PokemonDomain] {
        try self.remoteDataSource.loadData()
    }
    
    func add(pokemon: PokemonDomain) async throws {
        self.localDataSource.addPokemon(pokemonDB: PokemonData(from: pokemon))
    }
    
    func delete(pokemonId: UUID) async throws {
        self.localDataSource.deletePokemonById(pokemonId: pokemonId)
    }
    
}
