//
//  PokemonDetailViewModel.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/1/25.
//

import SwiftUI
import SwiftData

final class PokemonDetailViewModel: ObservableObject {
    private let repository: PokemonDataRepository
    
    init(repository: PokemonDataRepository){
        self.repository = repository
    }
}
