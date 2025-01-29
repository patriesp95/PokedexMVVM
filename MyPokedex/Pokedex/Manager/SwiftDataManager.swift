//
//  SwiftDataManager.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataManager {
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    static let shared = SwiftDataManager()
    
    private init(){
        self.modelContainer = try! ModelContainer(for: PokemonData.self)
        self.modelContext = modelContainer.mainContext
    }

}
