//
//  PokemonUi.swift
//  MyPokedex
//
//  Created by patricia.martinez on 17/1/25.
//
import SwiftUI

struct PokemonUi: Identifiable{
    var id = UUID()
    var name: String
    var type: [String]
    let imageURL: URL?
}
