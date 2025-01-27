//
//  RemoteDataSource.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/1/25.
//
import Foundation
import SwiftData

struct RemoteDataSource: RemoteDataSourceProtocol {
    let url = Bundle.main.url(forResource: "pokemons", withExtension: "json")!
    func loadData() throws -> [PokemonDomain]{
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([PokemonDomain].self, from: data)
    }
}

