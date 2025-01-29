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

final class MyPokedexPokemonViewModelTests: XCTestCase {
    
    var sut: PokemonViewModel!
    private var mockRepository: MockPokemonRepository!
    
    let pokemon = PokemonDomain(name: "Bulbasaur", type: ["Grass", "Poison"])
    
    override func setUpWithError() throws {
        mockRepository = MockPokemonRepository(remoteDataSource: RemoteDataSource(), localDataSource: LocalDataSource())
        sut = PokemonViewModel(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
        try super.tearDownWithError()
    }

    func testLoadData() async throws {
        let _ = try sut.loadPokemons()
    }
    
    func testAddPokemon() async throws{
        try await sut.insertPokemon(pokemon: PokemonUi(from: pokemon))
        try await sut.insertPokemon(pokemon: pokemon.fromDomainLayerToUiLayer())
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
            try await SwiftDataManager.shared.modelContainer.mainContext.delete(model: PokemonData.self)
            await SwiftDataManager.shared.modelContainer.mainContext.insert(myPokemon)
            try await SwiftDataManager.shared.modelContext.save()
            let descriptor = FetchDescriptor<PokemonData>()
            let pokemons = try await SwiftDataManager.shared.modelContainer.mainContext.fetch(descriptor)
        
            XCTAssertEqual(pokemons.count, 1)
        } catch {
            XCTFail()
        }
    }
    
    override func delete(pokemonId: UUID) async throws {
        let pokeId = pokemonId
        do {
            try await SwiftDataManager.shared.modelContext.delete(model: PokemonData.self, where: #Predicate<PokemonData>{
                $0.id == pokeId
            })
            try await SwiftDataManager.shared.modelContext.save()
            let pokemons = [] as! [PokemonData]
            XCTAssertEqual(pokemons.count, 0)
        } catch {
            XCTFail()
        }

    }
}
