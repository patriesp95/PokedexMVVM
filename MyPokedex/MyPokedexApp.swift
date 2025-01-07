//
//  MyPokedexApp.swift
//  MyPokedex
//
//  Created by patricia.martinez on 7/1/25.
//

import SwiftUI
import SwiftData

@main
struct MyPokedexApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print(URL.documentsDirectory)
                }
        }
        .modelContainer(for: PokemonData.self)
    }
}
