//
//  Tile.swift
//  Jobber
//
//  Created by Matteo on 12/04/2022.
//

import SwiftUI

struct Tile<Label: View>: View {
    
    let label: Label
    
    init(@ViewBuilder _ label: () -> Label, color: Color, opacity: Double = 0.2) {
        self.label = label()
        self.color = color
        self.opacity = opacity
    }
    
    let color: Color
    
    let opacity: Double
    
    var body: some View {
        label
            .foregroundColor(color)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 5).fill(color).opacity(opacity))
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        Tile({
            Label("Test", systemImage: "magnifyingglass")
                .font(.system(size: 16, weight: .bold))
        }, color: .red).previewLayout(.sizeThatFits)
    }
}
