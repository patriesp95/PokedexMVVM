//
//  TypeFilterChip.swift
//  MyPokedex
//

import SwiftUI

struct TypeFilterChip: View {
    let type: PokemonElementType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(type.rawValue.uppercased())
                .font(.caption.weight(.bold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .pokemonTypeCapsuleStyle(type, filled: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack {
        TypeFilterChip(type: .fire, isSelected: true, action: {})
        TypeFilterChip(type: .water, isSelected: false, action: {})
    }
    .padding()
}
