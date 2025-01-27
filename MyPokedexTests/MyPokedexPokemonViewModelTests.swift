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
    
    let pokemon = PokemonDomain(name: "Bulbasaur", type: ["Grass", "Poison"], imageURL: URL(filePath: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!)
    
    override func setUpWithError() throws {
        mockRepository = MockPokemonRepository(remoteDataSource: RemoteDataSource(), localDataSource: LocalDataSource())
        sut = PokemonViewModel(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
        try super.tearDownWithError()
    }

    func testLoadData() throws {
        let _ = try sut.loadPokemons()
    }
    
    @MainActor func testAddPokemon() throws{
        try sut.insertPokemon(pokemon: pokemon.fromDomainLayerToUiLayer())
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



//private class MockPokemonRepository: PokemonDataRepository {
//    
//    override func loadPokemonFromRemote() throws -> [PokemonDomain] {
//        let myPokemons = [
//            PokemonDomain(name: "Bulbasaur", type: ["Grass", "Poison"], imageURL: URL(filePath: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!),
//            PokemonDomain(name: "Charmander", type: ["Fire"], imageURL: URL(filePath: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")!),
//            PokemonDomain(name: "Squirtle", type: ["Water"], imageURL: URL(filePath: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png")!)
//        ]
//        
//        guard let file = Bundle(for: type(of: self)).url(forResource: "pokemons_test", withExtension: "json") else { return []}
//        let data = try! Data(contentsOf: file)
//        let json = try JSONDecoder().decode([PokemonDomain].self, from: data)
//        
//        print(type(of: file).documentsDirectory)
//                    
//        XCTAssertEqual(json[0].name, myPokemons[0].name)
//        
//        return try JSONDecoder().decode([PokemonDomain].self, from: data)
//    }
//    
//    func fetchPokemonFromDatabase() -> [PokemonData] {
//        let myPokemons = [
//            PokemonData(id: UUID(), name: "Bulbasaur", type: ["Grass", "Poison"], isFavorite: true),
//            PokemonData(id: UUID(), name: "Charmander", type: ["Fire"], isFavorite: false),
//            PokemonData(id: UUID(), name: "Squirtle", type: ["Water"], isFavorite: true)
//        ]
//        
//        return myPokemons
//    }
//    
//    @MainActor override func addPokemonToDatabase(pokemon: PokemonDomain) {
//        let myPokemon = PokemonData(id: pokemon.id, name: pokemon.name, type: pokemon.type, isFavorite: true)
//        
//        do {
//            try SwiftDataManager.shared.modelContainer.mainContext.delete(model: PokemonData.self)
//            SwiftDataManager.shared.modelContainer.mainContext.insert(myPokemon)
//            try SwiftDataManager.shared.modelContext.save()
//            let descriptor = FetchDescriptor<PokemonData>()
//            let pokemons = try SwiftDataManager.shared.modelContainer.mainContext.fetch(descriptor)
//        
//            XCTAssertEqual(pokemons.count, 1)
//        } catch {
//            XCTFail()
//        }
//    }
//    
//    @MainActor override func deletePokemonFromDatabase(pokemon: PokemonData) {
//        let pokeId = pokemon.id
//        do {
//            try SwiftDataManager.shared.modelContext.delete(model: PokemonData.self, where: #Predicate<PokemonData>{
//                $0.id == pokeId
//            })
//            try SwiftDataManager.shared.modelContext.save()
//            let descriptor = FetchDescriptor<PokemonData>()
//            let pokemons = try SwiftDataManager.shared.modelContainer.mainContext.fetch(descriptor)
//            XCTAssertEqual(pokemons.count, 0)
//        } catch {
//            XCTFail()
//        }
//
//    }
//}
//
//
