//
//  TypeBadge.swift
//  MyPokedex
//

import SwiftUI

struct TypeBadge: View {
    let type: String

    private var style: PokemonElementType? { type.pokemonElementType }

    var body: some View {
        Text(type.uppercased())
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .pokemonTypeCapsuleStyle(style, filled: true)
    }
}

#Preview {
    HStack {
        TypeBadge(type: "Grass")
        TypeBadge(type: "Electric")
        TypeBadge(type: "Fairy")
    }
    .padding()
}
