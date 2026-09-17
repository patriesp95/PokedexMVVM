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
        PokemonTypeFilter.apply(viewmodel.pokemons, selectedTypes: selectedTypes)
    }

    private var availableTypes: [PokemonElementType] {
        let loadedTypes = Set(viewmodel.pokemons.flatMap(\.type).compactMap(\.pokemonElementType))
        return PokemonElementType.allCases.filter(loadedTypes.contains)
    }

    private func toggle(_ type: PokemonElementType) {
        selectedTypes = PokemonTypeFilter.toggling(type, in: selectedTypes)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewmodel.pokemons.isEmpty {
                    ContentUnavailableView(
                        "No se pudieron cargar los Pokémon",
                        systemImage: "exclamationmark.triangle",
                        description: Text("Inténtalo de nuevo más tarde.")
                    )
                } else if filteredPokemons.isEmpty {
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
                        ForEach(availableTypes, id: \.self) { type in
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
