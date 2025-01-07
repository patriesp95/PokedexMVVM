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
    func loadData<T>() throws -> T where T: Codable {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

