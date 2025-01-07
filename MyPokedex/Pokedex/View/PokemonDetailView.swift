//
//  PokemonDetailView.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/1/25.
//

import SwiftUI

struct PokemonDetailView: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        Form {
            Section {
                Text(pokemon.name)
            } header: {
                Text("Name")
            }
            Section {
                Text(pokemon.types)
            } header: {
                Text("Type")
            }
        }
        .navigationTitle("Pokemon's Main Data")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PokemonDetailView(pokemon: .test)
}
