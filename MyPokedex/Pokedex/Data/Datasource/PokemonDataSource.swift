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

@MainActor
protocol LocalDataSourceProtocol: Sendable {
    func fetchPokemon() throws -> [PokemonDomain]
    func addPokemon(pokemonDB: PokemonData ) throws
    func deletePokemonById(pokemonId:UUID) throws
}
