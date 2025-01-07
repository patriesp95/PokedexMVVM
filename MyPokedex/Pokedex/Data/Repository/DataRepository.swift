//
//  DataInteractor.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import Foundation
import SwiftData

protocol PokemonDataRepositoryProtocol {
    func loadData<T>() throws -> T where T: Codable
    func fetchPokemon() async -> [PokemonData]
    func addPokemon(pokemon: PokemonData)
    func deletePokemon(pokemon: PokemonData)
}

class PokemonDataRepository: @preconcurrency PokemonDataRepositoryProtocol {
        
    private let remoteDataSource: RemoteDataSource
    private let localDataSource: LocalDataSource
    
    static let shared = PokemonDataRepository(remoteDataSource: RemoteDataSource(), localDataSource: LocalDataSource())
    
    init(remoteDataSource: RemoteDataSource, localDataSource: LocalDataSource) {
            self.remoteDataSource = remoteDataSource
            self.localDataSource = localDataSource
    }
    
    func loadData<T>() throws -> T where T : Decodable, T : Encodable {
        try self.remoteDataSource.loadData()
    }
    
    
    @MainActor func fetchPokemon() -> [PokemonData] {
        self.localDataSource.fetchPokemon()
    }
    
    @MainActor func addPokemon(pokemon: PokemonData) {
        self.localDataSource.addPokemon(pokemonDB: pokemon)
    }
    
    @MainActor func deletePokemon(pokemon: PokemonData) {
        self.localDataSource.deletePokemon(pokemonDB: pokemon)
    }
}
