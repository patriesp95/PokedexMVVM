//
//  PokeCell.swift
//  MySwiftUIPokedex
//
//  Created by patricia.martinez on 7/10/24.
//

import SwiftUI

struct PokeCell: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(pokemon.name)
                    .font(.headline)
                Text(pokemon.types)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            AsyncImage(url: pokemon.imageURL) { pokeImage in
                pokeImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .background{
                        Rectangle().fill(Color(white: 0.9))
                    }
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            } placeholder: {
                Image(systemName: "tortoise")
            }

        }
    }
}

#Preview {
    PokeCell(pokemon: Pokemon.test)
}
