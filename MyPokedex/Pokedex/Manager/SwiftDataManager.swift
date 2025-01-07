//
//  SwiftDataManager.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 2/1/25.
//

import Foundation
import SwiftData

final class SwiftDataManager {
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataManager()
    
    @MainActor
    private init(){
        self.modelContainer = try! ModelContainer(for: PokemonData.self)
        self.modelContext = modelContainer.mainContext
    }

}
