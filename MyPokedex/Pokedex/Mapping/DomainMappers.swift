//
//  DomainMappers.swift
//  MyPokedex
//
//  Created by patricia.martinez on 17/1/25.
//

import SwiftUI

extension PokemonDomain {
    func fromDomainLayerToDataLayer() -> PokemonData {
        return PokemonData(id: self.id, name: self.name, type: self.type, isFavorite: true, imageURL: self.imageURL, stats: self.stats)
    }

    func fromDomainLayerToUiLayer() -> PokemonUi {
        return PokemonUi(name: self.name, type: self.type, imageURL: self.imageURL, stats: self.stats)
    }

}

extension PokemonDomain {
    init(from data: PokemonData) throws {
        self.name = data.name
        self.type = data.type
        self.imageURL = data.imageURL
        self.stats = data.stats
    }

    init(with ui: PokemonUi) throws {
        self.name = ui.name
        self.type = ui.type
        self.imageURL = ui.imageURL
        self.stats = ui.stats
    }
}
