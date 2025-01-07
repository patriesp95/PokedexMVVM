//
//  ContentView.swift
//  MyPokedex
//
//  Created by patricia.martinez on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PokemonListView()
                .tabItem {
                    Label("Pokemons", systemImage: "tortoise")
                }
            FavoritedPokemonsView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }

        }
    }
}

#Preview {
    ContentView()
}
