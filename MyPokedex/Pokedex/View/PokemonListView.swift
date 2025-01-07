//
//  PokemonListView.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 3/10/24.
//

import SwiftUI
import SwiftData

struct PokemonListView: View {
    @StateObject var vm = PokemonViewModel(repository: .shared)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.pokemons) { pokemon in
                    NavigationLink {
                        PokemonDetailView(pokemon: pokemon)
                    } label: {
                        PokeCell(pokemon: pokemon)
                            .swipeActions(edge: .leading) {
                                Button {
                                    vm.insertPokemon(pokemon: pokemon)
                                } label: {
                                    Label("Favorite", systemImage: "star")
                                }
                                .tint(.yellow)
                            }
                    }
                }
            }
            .listRowSpacing(20)
            .listStyle(.grouped)
            .navigationTitle("Pokedex MVVM")
        }
    }
}

#Preview {
    PokemonListView()
}
