//
//  PokemonDataSource.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/1/25.
//
import Foundation
import SwiftData

protocol RemoteDataSourceProtocol {
    var url: URL { get }
    func loadData<T>() throws -> T where T: Codable
}

protocol LocalDataSourceProtocol {
    func fetchPokemon() -> [PokemonData]
    func addPokemon(pokemonDB: PokemonData ) throws
    func deletePokemon(pokemonDB:PokemonData) throws
}
