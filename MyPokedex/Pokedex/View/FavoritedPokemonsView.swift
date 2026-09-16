//
//  FavoritedPokemons.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import SwiftUI
import SwiftData

struct FavoritedPokemonsView: View {
    @StateObject var viewmodel = FavoritedPokemonViewModel(repository: .shared)
    @Query(sort: \PokemonData.name, animation: .default) var favoritedPokemons: [PokemonData]
    
    var body: some View {
        List(favoritedPokemons, id: \.self) { favPokemon in
            HStack {
                PokeCell(pokemon: PokemonUi(from: favPokemon.fromDataLayerToDomainLayer()))
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .swipeActions {
                Button(role: .destructive){
                    Task {
                        do {
                            try await viewmodel.deletePokemonById(PokemonId: favPokemon.id)
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .listStyle(.plain)
    }
}
