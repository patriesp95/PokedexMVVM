//
//  PokemonTypeFilterTests.swift
//  MyPokedexTests
//

import XCTest
@testable import MyPokedex

final class PokemonTypeFilterTests: XCTestCase {

    private let bulbasaur = PokemonUi(name: "Bulbasaur", type: ["Grass", "Poison"], imageURL: nil, stats: nil)
    private let charmander = PokemonUi(name: "Charmander", type: ["Fire"], imageURL: nil, stats: nil)
    private let squirtle = PokemonUi(name: "Squirtle", type: ["Water"], imageURL: nil, stats: nil)

    private var allPokemons: [PokemonUi] { [bulbasaur, charmander, squirtle] }

    func testEmptySelectionReturnsAllPokemons() {
        let result = PokemonTypeFilter.apply(allPokemons, selectedTypes: [])
        XCTAssertEqual(result.map(\.name), allPokemons.map(\.name))
    }

    func testSingleTypeReturnsOnlyMatchingPokemons() {
        let result = PokemonTypeFilter.apply(allPokemons, selectedTypes: [.fire])
        XCTAssertEqual(result.map(\.name), ["Charmander"])
    }

    func testMultipleTypesActAsLogicalOr() {
        let result = PokemonTypeFilter.apply(allPokemons, selectedTypes: [.fire, .water])
        XCTAssertEqual(Set(result.map(\.name)), ["Charmander", "Squirtle"])
    }

    func testTypeWithNoMatchesReturnsEmptyResult() {
        let result = PokemonTypeFilter.apply(allPokemons, selectedTypes: [.electric])
        XCTAssertTrue(result.isEmpty)
    }

    func testPokemonWithUnrecognizedOrMissingTypeIsExcluded() {
        let mysteryMon = PokemonUi(name: "MysteryMon", type: ["Cosmic"], imageURL: nil, stats: nil)
        let noTypeMon = PokemonUi(name: "NoTypeMon", type: [], imageURL: nil, stats: nil)
        let result = PokemonTypeFilter.apply([mysteryMon, noTypeMon], selectedTypes: [.normal])
        XCTAssertTrue(result.isEmpty)
    }

    func testTogglingAddsTypeWhenNotSelected() {
        let result = PokemonTypeFilter.toggling(.fire, in: [])
        XCTAssertEqual(result, [.fire])
    }

    func testTogglingRemovesTypeWhenAlreadySelected() {
        let result = PokemonTypeFilter.toggling(.fire, in: [.fire, .water])
        XCTAssertEqual(result, [.water])
    }
}
