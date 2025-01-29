//
//  DomainMappers.swift
//  MyPokedex
//
//  Created by patricia.martinez on 17/1/25.
//

import SwiftUI

extension PokemonDomain {
    func fromDomainLayerToDataLayer() -> PokemonData {
        return PokemonData(id: self.id, name: self.name, type: self.type, isFavorite: true)
    }
    
    func fromDomainLayerToUiLayer() -> PokemonUi {
        return PokemonUi(name: self.name, type: self.type, imageURL: nil)
    }
    
}

extension PokemonDomain {
    init(from data: PokemonData) throws {
        self.name = data.name
        self.type = data.type
    }
    
    init(with ui: PokemonUi) throws {
        self.name = ui.name
        self.type = ui.type
    }
}
