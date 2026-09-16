//
//  PokemonDetailView.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/1/25.
//

import SwiftUI

    struct PokemonDetailView: View {

    private static let maxStatValue = 150

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

                if let stats = pokemon.stats {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Estadísticas base")
                            .font(.system(.headline, design: .rounded).weight(.bold))

                        VStack(spacing: 12) {
                            StatBar(label: "PS", value: stats.hp, maxValue: Self.maxStatValue, color: PokemonElementType.grass.badgeColor)
                            StatBar(label: "Ataque", value: stats.attack, maxValue: Self.maxStatValue, color: PokemonElementType.fire.badgeColor)
                            StatBar(label: "Defensa", value: stats.defense, maxValue: Self.maxStatValue, color: PokemonElementType.water.badgeColor)
                            StatBar(label: "Velocidad", value: stats.speed, maxValue: Self.maxStatValue, color: PokemonElementType.electric.badgeColor)
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
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
