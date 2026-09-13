//
//  MyPokedexTests.swift
//  MyPokedexTests
//
//  Created by patricia.martinez on 7/1/25.
//

import XCTest
import SwiftData
@testable import MyPokedex
import SwiftUI

@MainActor
final class MyPokedexFavoritedPokemonViewModelTests : XCTestCase {
    
    var sut: FavoritedPokemonViewModel!
    var sut2: PokemonViewModel!
    private var mockRepository: MockPokemonRepository!
    
    let pokemon = PokemonDomain(name: "Bulbasaur", type: ["Grass", "Poison"])
    
    override func setUp() async throws {
        mockRepository = MockPokemonRepository(remoteDataSource: RemoteDataSource(), localDataSource: LocalDataSource())
        sut = FavoritedPokemonViewModel(repository: mockRepository)
        sut2 = PokemonViewModel(repository: mockRepository)
    }

    override func tearDown() async throws {
        sut = nil
        sut2 = nil
        mockRepository = nil
        try await super.tearDown()
    }
    
    func testDeletePokemon() async throws {
        
        let pokemonDb = PokemonData(id: pokemon.id, name: pokemon.name, type: pokemon.type, isFavorite: true)
        try await sut2.insertPokemon(pokemon: PokemonUi(from: pokemon))
        try await sut.deletePokemonById(PokemonId: pokemonDb.id)
    }
    
    func testFetchPokemonFromDb() async throws {
        do {
            let pokemons = try mockRepository.load()
            if pokemons.count > 0 {
                XCTAssertTrue(!pokemons.isEmpty)
            }
        } catch {
            print(error)
        }
    }
}

private class MockPokemonRepository: PokemonDataRepository {
    
    override func load() throws -> [PokemonDomain] {
        let myPokemons = [
            PokemonDomain(name: "Bulbasaur", type: ["Grass", "Poison"]),
            PokemonDomain(name: "Charmander", type: ["Fire"]),
            PokemonDomain(name: "Squirtle", type: ["Water"])
        ]
        
        guard let file = Bundle(for: type(of: self)).url(forResource: "pokemons_test", withExtension: "json") else { return []}
        let data = try! Data(contentsOf: file)
        let json = try JSONDecoder().decode([PokemonDomain].self, from: data)
        
        print(type(of: file).documentsDirectory)
                    
        XCTAssertEqual(json[0].name, myPokemons[0].name)
        
        return try JSONDecoder().decode([PokemonDomain].self, from: data)
    }

    override func add(pokemon: PokemonDomain) async throws {
        let myPokemon = PokemonData(id: pokemon.id, name: pokemon.name, type: pokemon.type, isFavorite: true)
        
        
        do {
            try SwiftDataManager.shared.modelContainer.mainContext.delete(model: PokemonData.self)
            SwiftDataManager.shared.modelContainer.mainContext.insert(myPokemon)
            try SwiftDataManager.shared.modelContext.save()
            let descriptor = FetchDescriptor<PokemonData>()
            let pokemons = try SwiftDataManager.shared.modelContainer.mainContext.fetch(descriptor)

            XCTAssertEqual(pokemons.count, 1)
        } catch {
            XCTFail()
        }
    }

    override func delete(pokemonId: UUID) async throws {
        do {
            let items = try SwiftDataManager.shared.modelContext.fetch(FetchDescriptor<PokemonData>())
            for item in items where item.id == pokemonId {
                SwiftDataManager.shared.modelContext.delete(item)
            }
            try SwiftDataManager.shared.modelContext.save()
            let pokemons = [] as! [PokemonData]
            XCTAssertEqual(pokemons.count, 0)
        } catch {
            XCTFail()
        }

    }
}

