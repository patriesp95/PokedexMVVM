//
//  PokemonDetailView.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/1/25.
//

import SwiftUI

    struct PokemonDetailView: View {
    
    let pokemon: PokemonUi

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PokemonAvatar(imageURL: pokemon.imageURL, primaryType: pokemon.type.first, size: 160)

                VStack(spacing: 8) {
                    if let dexNumber = pokemon.dexNumber {
                        Text("Nº \(dexNumber)")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                    Text(pokemon.name)
                        .font(.system(.largeTitle, design: .rounded).weight(.heavy))
                    HStack(spacing: 8) {
                        ForEach(pokemon.type, id: \.self) { type in
                            TypeBadge(type: type)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(pokemon.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PokemonDetailView(pokemon: PokemonUi.test)
}
