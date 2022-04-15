//
//  QualificationView.swift
//  Jobber
//
//  Created by Matteo on 07/04/2022.
//

import SwiftUI

struct QualificationView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @Binding var qualification: String
    let qualifications = ["Cadre", "Non cadre"]
    
    var body: some View {
        List {
            Section {
                ForEach(qualifications, id: \.self) { value in
                    HStack {
                        Button {
                            qualification = value
                        } label: {
                            Text(value)
                                .tint(colorScheme == .dark ? .white : .black)
                        }
                        Spacer()
                        if (qualification == value) {
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
                    qualification = ""
                }
            }
        }
    }
}
