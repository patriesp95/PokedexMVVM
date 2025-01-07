//
//  FavoritedPokemons.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import SwiftUI
import SwiftData

struct FavoritedPokemonsView: View {
    @StateObject var vm = FavoritedPokemonViewModel(repository: .shared)
    @Query(sort: \PokemonData.name, animation: .default) var favoritedPokemons: [PokemonData]
    
    var body: some View {
        List(favoritedPokemons, id: \.self) { favPokemon in
            HStack {
                VStack(alignment: .leading){
                    Text(favPokemon.name)
                        .font(.headline)
                    Text(favPokemon.types)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                }
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            .swipeActions {
                Button(role: .destructive){
                    vm.deletePokemon(pokemon: favPokemon)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}
