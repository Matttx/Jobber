//
//  JobDetailsView.swift
//  Jobber
//
//  Created by Matteo on 12/04/2022.
//

import SwiftUI

struct JobDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    
    let job: Job
    
    var body: some View {
        
        let isDark = colorScheme == .dark
        
        let isWage = job.salaire.libelle! != "Salaire non précisé"
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(job.intitule)
                        .font(.title)
                        .fontWeight(.bold)
                    HStack {
                        Image(systemName: "building.2")
                            .foregroundColor(.blue)
                        Text(job.entreprise.nom!)
                            .foregroundColor(Color(uiColor: .systemGray))
                        Spacer()
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                        Text(job.lieuTravail)
                        Spacer()
                    }.padding(.bottom)
                    
                    Text("Détails du poste")
                        .font(.title2)
                        .fontWeight(.semibold)
                    VStack(alignment: .leading) {
                        Text("Salaire")
                            .fontWeight(.semibold)
                        Tile({
                            Label(job.salaire.libelle!, systemImage: isWage ? "creditcard.fill" : "exclamationmark.triangle.fill").font(.system(size: 15, weight: .semibold))
                            
                        }, color: job.salaire.libelle! == "Salaire non précisé" ? .yellow : .gray)
                        
                        Text("Type de contrat")
                            .fontWeight(.semibold)
                        Tile({
                            Label("\(job.typeContrat), \(job.dureeTravailLibelleConverti)", systemImage: "clock").font(.system(size: 15, weight: .semibold))
                            
                        }, color: .cyan)
                        Text("Expérience requise")
                            .fontWeight(.semibold)
                        Tile({
                            Label(job.experienceLibelle, systemImage: "star.circle.fill").font(.system(size: 15, weight: .semibold))
                            
                        }, color: .orange)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(uiColor: isDark ? .secondarySystemBackground : .systemBackground).cornerRadius(10))
                    .padding(.bottom)
                    
                    Text("Description du poste")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading) {
                        Text(job.description)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(uiColor: isDark ? .secondarySystemBackground : .systemBackground).cornerRadius(10))
                        .padding(.bottom)
                    
                    Button {
                        openURL(URL(string: job.origineOffre.urlOrigine!)!)
                    } label: {
                        Text("Postuler")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                }.frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
            }.background(Color(uiColor: isDark ? .systemBackground : .systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(uiColor: .systemGray))
                    }

                }
            }
        }
    }
}


struct JobDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            JobDetailsView(job: Job.data)
            
            JobDetailsView(job: Job.data)
                .preferredColorScheme(.dark)
        }
    }
}
