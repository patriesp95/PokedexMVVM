//
//  PokeCell.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/10/24.
//

import SwiftUI

struct PokeCell: View {
    let pokemon: PokemonUi

    var body: some View {
        HStack(spacing: 14) {
            PokemonAvatar(imageURL: pokemon.imageURL, primaryType: pokemon.type.first)
            VStack(alignment: .leading, spacing: 6) {
                if let dexNumber = pokemon.dexNumber {
                    Text("Nº \(dexNumber)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }
                Text(pokemon.name)
                    .font(.system(.headline, design: .rounded).weight(.bold))
                HStack(spacing: 6) {
                    ForEach(pokemon.type, id: \.self) { type in
                        TypeBadge(type: type)
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 12, y: 4)
    }
}

#Preview {
    PokeCell(pokemon: PokemonUi.test)
}
