//
//  StatBar.swift
//  MyPokedex
//

import SwiftUI

struct StatBar: View {
    let label: String
    let value: Int
    let maxValue: Int
    let color: Color

    private var fraction: CGFloat {
        guard maxValue > 0 else { return 0 }
        return min(1, max(0, CGFloat(value) / CGFloat(maxValue)))
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 78, alignment: .leading)

            GeometryReader { geometry in
                Capsule()
                    .fill(Color(.systemGray5))
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(color)
                            .frame(width: geometry.size.width * fraction)
                    }
            }
            .frame(height: 8)

            Text("\(value)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary)
                .frame(width: 30, alignment: .trailing)
                .monospacedDigit()
        }
    }
}

#Preview {
    VStack(spacing: 14) {
        StatBar(label: "PS", value: 115, maxValue: 150, color: .green)
        StatBar(label: "Ataque", value: 45, maxValue: 150, color: .orange)
        StatBar(label: "Defensa", value: 20, maxValue: 150, color: .blue)
        StatBar(label: "Velocidad", value: 20, maxValue: 150, color: .yellow)
    }
    .padding()
}
