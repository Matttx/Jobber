//
//  ExperienceView.swift
//  Jobber
//
//  Created by Matteo on 07/04/2022.
//

import SwiftUI

struct ExperienceView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var experience: String
    let experiences = ["Moins d'un an", "Un à trois ans", "Plus de trois ans"]
    
    var body: some View {
        List {
            Section {
                ForEach(experiences, id: \.self) { value in
                    HStack {
                        Button {
                            experience = value
                        } label: {
                            Text(value)
                                .tint(colorScheme == .dark ? .white : .black)
                        }

                        Spacer()
                        if (experience == value) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Effacer") {
                    experience = ""
                }
            }
        }
    }
}
