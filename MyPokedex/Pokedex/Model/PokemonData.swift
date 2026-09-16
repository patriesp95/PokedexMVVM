//
//  PokemonData.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import Foundation
import SwiftData

@Model
final class PokemonData: Identifiable {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var type: [String]
    var isFavorite: Bool
    var imageURL: URL?

    init(id: UUID, name: String, type: [String], isFavorite: Bool, imageURL: URL? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.isFavorite = isFavorite
        self.imageURL = imageURL
    }
}
