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
    func loadData() throws -> [PokemonDomain]
}

protocol LocalDataSourceProtocol {
    func fetchPokemon() -> [PokemonData]
    func addPokemon(pokemonDB: PokemonData ) throws
    func deletePokemonById(pokemonId:UUID) throws
}
