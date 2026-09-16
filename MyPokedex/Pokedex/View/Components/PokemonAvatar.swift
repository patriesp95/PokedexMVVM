//
//  PokemonAvatar.swift
//  MyPokedex
//

import SwiftUI

struct PokemonAvatar: View {
    let imageURL: URL?
    let primaryType: String?
    var size: CGFloat = 60

    private var style: PokemonElementType? { primaryType?.pokemonElementType }

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
            .fill(style?.tintColor ?? Color(.systemGray6))
            .frame(width: size, height: size)
            .overlay {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(size * 0.14)
                    default:
                        Image(systemName: "hare.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(size * 0.28)
                            .foregroundStyle(style?.badgeColor ?? .secondary)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: size * 0.3, style: .continuous))
    }
}

#Preview {
    HStack {
        PokemonAvatar(imageURL: PokemonUi.test.imageURL, primaryType: "Electric")
        PokemonAvatar(imageURL: nil, primaryType: "Grass", size: 160)
    }
    .padding()
}
