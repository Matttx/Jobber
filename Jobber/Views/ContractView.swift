//
//  ContractView.swift
//  Jobber
//
//  Created by Matteo on 07/04/2022.
//

import SwiftUI

struct ContractView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @Binding var contracts: [String: String]
    let contractsArray = ["CDI": "CDI", "CDD": "CDD", "MIS": "Mission intérimaire", "FS": "Contrat de professionnalisation", "E2": "Contrat d'apprentissage", "SAI": "Saisonnier"]
    
    var body: some View {
        List {
            Section {
                ForEach(contractsArray.sorted(by: <), id: \.key) { key, value in
                    HStack {
                        Button {
                            if (contracts.values.contains(value)) {
                                contracts = contracts.filter { $0.value != value}
                            } else {
                                contracts[key] = value
                            }
                        } label: {
                            Text(value)
                                .tint(colorScheme == .dark ? .white : .black)
                        }
                        
                        Spacer()
                        if (contracts.values.contains(value)) {
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
                    contracts.removeAll()
                }
            }
        }
    }
}
