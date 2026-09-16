//
//  Extensions.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 3/10/24.
//

import Foundation

extension PokemonDomain {
    var types: String {
        type.formatted(.list(type: .and))
    }
}

extension PokemonData {
    var types: String {
        type.formatted(.list(type: .and))
    }
}

extension PokemonUi {
    var types: String {
        type.formatted(.list(type: .and))
    }

    var dexNumber: String? {
        guard let raw = imageURL?.deletingPathExtension().lastPathComponent,
              let number = Int(raw) else { return nil }
        return number.formatted(.number.precision(.integerLength(3)))
    }

    static let test = PokemonUi(name: "Pikachu", type: ["Electric"], imageURL: URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")!)
}
