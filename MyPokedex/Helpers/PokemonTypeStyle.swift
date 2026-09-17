//
//  PokemonTypeStyle.swift
//  MyPokedex
//

import SwiftUI

enum PokemonElementType: String, CaseIterable {
    case grass = "Grass"
    case poison = "Poison"
    case fire = "Fire"
    case water = "Water"
    case electric = "Electric"
    case normal = "Normal"
    case fairy = "Fairy"

    init?(rawType: String) {
        self.init(rawValue: rawType.capitalized)
    }

    var badgeColor: Color {
        switch self {
        case .grass: Color(red: 0x4C / 255, green: 0xA6 / 255, blue: 0x5B / 255)
        case .poison: Color(red: 0x9B / 255, green: 0x4F / 255, blue: 0xC2 / 255)
        case .fire: Color(red: 0xF0 / 255, green: 0x65 / 255, blue: 0x3C / 255)
        case .water: Color(red: 0x2E / 255, green: 0x86 / 255, blue: 0xD6 / 255)
        case .electric: Color(red: 0xF4 / 255, green: 0xC5 / 255, blue: 0x42 / 255)
        case .normal: Color(red: 0x8F / 255, green: 0x85 / 255, blue: 0x74 / 255)
        case .fairy: Color(red: 0xE8 / 255, green: 0x93 / 255, blue: 0xB7 / 255)
        }
    }

    var badgeTextColor: Color {
        switch self {
        case .electric: Color(red: 0x3A / 255, green: 0x2E / 255, blue: 0x00 / 255)
        case .fairy: Color(red: 0x5B / 255, green: 0x2A / 255, blue: 0x3D / 255)
        default: .white
        }
    }

    var tintColor: Color {
        badgeColor.opacity(0.16)
    }
}

extension String {
    var pokemonElementType: PokemonElementType? {
        PokemonElementType(rawType: self)
    }
}

extension View {
    func pokemonTypeCapsuleStyle(_ type: PokemonElementType?, filled: Bool) -> some View {
        let tint = type?.badgeColor ?? .gray
        return self
            .foregroundStyle(filled ? (type?.badgeTextColor ?? .white) : tint)
            .background {
                Capsule().fill(filled ? tint : Color(.secondarySystemBackground))
            }
            .overlay {
                if !filled {
                    Capsule().strokeBorder(tint, lineWidth: 1.5)
                }
            }
    }
}
