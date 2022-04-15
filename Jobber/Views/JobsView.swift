//
//  JobsView.swift
//  Jobber
//
//  Created by Matteo on 08/04/2022.
//

import SwiftUI

struct JobsView: View {
    
    @EnvironmentObject private var jobVM: JobsViewModel
    
    @State private var showingSheet = false
    
    @State private var searchText = ""
    
    @State private var selectedJob: Job?
        
    var searchResults: [Job] {
        guard let jobs = jobVM.jobs else {
            return []
        }
        if searchText.isEmpty {
            return jobs
        } else {
            return jobs.filter { $0.intitule.lowercased().contains(searchText.lowercased()) || $0.lieuTravail.lowercased().contains(searchText.lowercased()) || $0.entreprise.nom!.lowercased().contains(searchText.lowercased())}
        }
    }

    var body: some View {
        ScrollView {
            if (jobVM.jobs != nil && jobVM.jobs!.count > 0) {
                ScrollView {
                    if (searchText.isEmpty) {
                        HStack {
                            Text("Voici les résultats trouvés pour la recherche: ") +
                            Text(jobVM.keyword).fontWeight(.bold)
                            Spacer()
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Color(UIColor.systemGray))
                        .padding(.horizontal)
                    }
                    ForEach(searchResults, id: \.id) { job in
                        JobPreview(job: job)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedJob = job
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                    }
                }
            } else {
                Text("Aucun job trouvé, essayez avec un autre mot-clé")
                    .foregroundColor(Color(uiColor: .systemGray))
            }
        }
        .navigationTitle("Résultats")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .sheet(item: $selectedJob, content: { job in
            JobDetailsView(job: job)
        })
        .searchable(text: $searchText, prompt: Text("Métier, ville, entreprise..."))
        .fullScreenCover(isPresented: $showingSheet) {
            SearchSheetView()
                .environmentObject(jobVM)
        }
    }
}

struct JobsView_Previews: PreviewProvider {
        
    static var previews: some View {
        JobsView()
            .environmentObject(JobsViewModel())
    }
}
