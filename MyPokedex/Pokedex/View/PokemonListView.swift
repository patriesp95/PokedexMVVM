//
//  PokemonListView.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 3/10/24.
//

import SwiftUI
import SwiftData


struct PokemonListView: View {
    @StateObject var viewmodel = PokemonViewModel(repository: .shared)
    @State private var selectedTypes: Set<PokemonElementType> = []

    private var filteredPokemons: [PokemonUi] {
        guard !selectedTypes.isEmpty else { return viewmodel.pokemons }
        return viewmodel.pokemons.filter { pokemon in
            pokemon.type.contains(where: { $0.pokemonElementType.map(selectedTypes.contains) ?? false })
        }
    }

    private func toggle(_ type: PokemonElementType) {
        if selectedTypes.contains(type) {
            selectedTypes.remove(type)
        } else {
            selectedTypes.insert(type)
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if filteredPokemons.isEmpty {
                    ContentUnavailableView(
                        "Sin resultados",
                        systemImage: "line.3.horizontal.decrease.circle",
                        description: Text("Ningún Pokémon tiene ese tipo.")
                    )
                } else {
                    List {
                        ForEach(filteredPokemons) { pokemon in
                            NavigationLink {
                                PokemonDetailView(pokemon: pokemon)
                            } label: {
                                PokeCell(pokemon: pokemon)
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            Task {
                                                do {
                                                    try await viewmodel.insertPokemon(pokemon: pokemon)
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        } label: {
                                            Label("Favorite", systemImage: "star")
                                        }
                                        .tint(.yellow)
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }
                        }
                    }
                    .listRowSpacing(20)
                    .listStyle(.plain)
                }
            }
            .safeAreaInset(edge: .top) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(PokemonElementType.allCases, id: \.self) { type in
                            TypeFilterChip(type: type, isSelected: selectedTypes.contains(type)) {
                                toggle(type)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(.bar)
            }
            .navigationTitle("Pokédex")
        }
    }
}

#Preview {
    PokemonListView()
}
