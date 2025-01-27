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

final class MyPokedexFavoritedPokemonViewModelTests : XCTestCase {
    
    var sut: FavoritedPokemonViewModel!
    var sut2: PokemonViewModel!
    private var mockRepository: MockPokemonRepository!
    
    let pokemon = PokemonDomain(name: "Bulbasaur", type: ["Grass", "Poison"])
    
    override func setUpWithError() throws {
        mockRepository = MockPokemonRepository(remoteDataSource: RemoteDataSource(), localDataSource: LocalDataSource())
        sut = FavoritedPokemonViewModel(repository: mockRepository)
        sut2 = PokemonViewModel(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        sut2 = nil
        mockRepository = nil
        try super.tearDownWithError()
    }
    
    @MainActor func testDeletePokemon() throws{
        
        let pokemonDb = PokemonData(id: pokemon.id, name: pokemon.name, type: pokemon.type, isFavorite: true)
        try sut2.insertPokemon(pokemon: pokemon.fromDomainLayerToUiLayer())
        try sut.deletePokemonById(PokemonId: pokemonDb.id)
    }
    
    @MainActor func testFetchPokemonFromDb() throws {
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
            PokemonDomain(name: "Bulbasaur", type: ["Grass", "Poison"], imageURL: URL(filePath: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!),
            PokemonDomain(name: "Charmander", type: ["Fire"], imageURL: URL(filePath: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")!),
            PokemonDomain(name: "Squirtle", type: ["Water"], imageURL: URL(filePath: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png")!)
        ]
        
        guard let file = Bundle(for: type(of: self)).url(forResource: "pokemons_test", withExtension: "json") else { return []}
        let data = try! Data(contentsOf: file)
        let json = try JSONDecoder().decode([PokemonDomain].self, from: data)
        
        print(type(of: file).documentsDirectory)
                    
        XCTAssertEqual(json[0].name, myPokemons[0].name)
        
        return try JSONDecoder().decode([PokemonDomain].self, from: data)
    }
    
//    func getPokemonFromDatabase() -> [PokemonData] {
//        let myPokemons = [
//            PokemonData(id: UUID(), name: "Bulbasaur", type: ["Grass", "Poison"], isFavorite: true),
//            PokemonData(id: UUID(), name: "Charmander", type: ["Fire"], isFavorite: false),
//            PokemonData(id: UUID(), name: "Squirtle", type: ["Water"], isFavorite: true)
//        ]
//        
//        return myPokemons
//    }
    
    @MainActor override func add(pokemon: PokemonDomain) {
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
    
    @MainActor override func delete(pokemonId: UUID) {
        let pokeId = pokemonId
        do {
            try SwiftDataManager.shared.modelContext.delete(model: PokemonData.self, where: #Predicate<PokemonData>{
                $0.id == pokeId
            })
            try SwiftDataManager.shared.modelContext.save()
            let pokemons = [] as! [PokemonData]
            XCTAssertEqual(pokemons.count, 0)
        } catch {
            XCTFail()
        }

    }
}

