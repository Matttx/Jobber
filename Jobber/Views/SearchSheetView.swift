//
//  SearchSheetView.swift
//  Jobber
//
//  Created by Matteo on 12/04/2022.
//

import SwiftUI

struct SearchSheetView: View {
    
    @EnvironmentObject var jobVM: JobsViewModel
    
    @State private var location = ""
    
    @FocusState private var locationIsFocused: Bool
    
    @State private var minWage = ""
    @State private var wagePeriod = ""
    let wages = ["Mensuel", "Annuel", "Horaire", "Cachet"]
    
    @State private var timeline = "1"
    let timelines = ["0": "Non précisé", "1": "Temps plein", "2": "Temps partiel"]
    
    @State private var experience = ""
    
    @State private var qualification = ""
    
    @State private var contracts: [String: String] = [:]
    
    @State private var contractsText = ""
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var wageIsFocused: Bool
    
    @State private var jobAlert = false
    @State private var wageAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(UIColor.systemGray3))
                        TextField("Développeur, Manager, ...", text: $jobVM.keyword)
                    }
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(Color(UIColor.systemGray3))
                        TextField("Code postal du lieu de travail", text: $location)
                            .keyboardType(.numberPad)
                            .focused($locationIsFocused)
                    }
                }
                Section {
                    HStack {
                        TextField("500", text: $minWage)
                            .keyboardType(.numberPad)
                            .focused($wageIsFocused)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        wageIsFocused = false
                                        locationIsFocused = false
                                    }
                                }
                            }
                        Spacer()
                        Text("€")
                    }
                    Picker("Salaire", selection: $wagePeriod) {
                        ForEach(wages, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    HStack {
                        Text("Salaire brut minimum")
                        Spacer()
                        if (!minWage.isEmpty || !wagePeriod.isEmpty) {
                            Button {
                                minWage = ""
                                wagePeriod = ""
                            } label: {
                                Text("Effacer")
                            }
                            
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: ContractView(contracts: $contracts)) {
                        HStack {
                            Text("Contrats")
                            Spacer()
                            Text(contracts.isEmpty ? "" : "\(contracts.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    Picker("Durée hebomadaire", selection: $timeline) {
                        ForEach(timelines.sorted(by: <), id: \.key) { _, value in
                            Text(value)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("Contrat / Durée hebdomadaire")
                } footer: {
                    Text(contracts.values.joined(separator: ", "))
                }
                
                Section {
                    NavigationLink(destination: ExperienceView(experience: $experience)) {
                        HStack {
                            Text("Expérience demandée")
                            Spacer()
                            Text(experience)
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination: QualificationView(qualification: $qualification)) {
                        HStack {
                            Text("Qualification")
                            Spacer()
                            Text(qualification)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Button {
                    fetchJobs()
                } label: {
                    HStack {
                        Spacer()
                        if (jobVM.isLoading) {
                            ProgressView()
                                .tint(.white)
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Trouve ton job")
                                .fontWeight(.bold)
                                .tint(.white)
                        }
                        Spacer()
                    }
                }.listRowBackground(Color.blue)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Annuler")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Veuillez renseigner un job", isPresented: $jobAlert) {
                Button("Ok", role: .cancel, action: {})
            }
            .alert("Si vous renseignez un salaire, veuillez selectionner une periode, et inversement.", isPresented: $wageAlert) {
                Button("Ok", role: .cancel, action: {})
            }
        }
    }
    
    func fetchJobs() {
        if (jobVM.keyword.count < 2) {
            jobAlert.toggle()
            return
        }
        var queryParams = "?motsCles=\(jobVM.keyword.folding(options: .diacriticInsensitive, locale: Locale.current))"
        
        if (!location.isEmpty) {
            queryParams += "&commune=\(location)"
        }
        
        if ((!minWage.isEmpty && wagePeriod.isEmpty) || (minWage.isEmpty && !wagePeriod.isEmpty)) {
            wageAlert.toggle()
            return
        }
        if (!minWage.isEmpty && !wagePeriod.isEmpty) {
            queryParams += "&salaireMin=\(minWage)&periodeSalaire=\(wagePeriod.prefix(1))"
        }
        
        if (contracts.count > 0) {
            for i in 0..<contracts.count {
                if (Array(contracts)[i].key == "FS" || Array(contracts)[i].key == "E2") {
                    if i == 0 {
                        queryParams += "&natureContrat=\(Array(contracts)[i].key)"
                    } else {
                        queryParams += ",\(Array(contracts)[i].key)"
                    }
                } else {
                    if i == 0 {
                        queryParams += "&typeContrat=\(Array(contracts)[i].key)"
                    } else {
                        queryParams += ",\(Array(contracts)[i].key)"
                    }
                }
            }
        }
        
        queryParams += "&dureeHebdo=\(timeline)"
        
        if (experience == "Moins d'un an") {
            queryParams += "&experience=1"
        } else if (experience == "Un à trois ans") {
            queryParams += "&experience=2"
        } else if (experience == "Plus de trois ans") {
            queryParams += "&experience=3"
        }
        
        if (qualification == "Cadre") {
            queryParams += "&qualification=9"
        } else if (qualification == "Non cadre") {
            queryParams += "&qualification=0"
        }
        
        jobVM.fetchJobs(queryParams: queryParams) {
            dismiss()
        }
    }
}

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView()
            .environmentObject(JobsViewModel())
    }
}
