//
//  JobPreview.swift
//  Jobber
//
//  Created by Matteo on 11/04/2022.
//

import SwiftUI

struct JobPreview: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let job: Job
    
    var body: some View {
                
        let isWage = job.salaire.libelle! != "Salaire non précisé"
        
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(job.intitule)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                HStack {
                    Image(systemName: "building.2")
                        .foregroundColor(.blue)
                    Text(job.entreprise.nom!)
                }
                .font(.system(size: 14))
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.red)
                    Text(job.lieuTravail)
                }
                .font(.system(size: 14))
                .padding(.bottom, 5)
                Tile({
                    Label(job.salaire.libelle!, systemImage: isWage ? "creditcard.fill" : "exclamationmark.triangle.fill").font(.system(size: 14, weight: .bold))
                    
                }, color: job.salaire.libelle! == "Salaire non précisé" ? .yellow : .gray)
                HStack {
                    Image(systemName: "clock")
                    Text("\(job.typeContrat), \(job.dureeTravailLibelleConverti)")
                }
                .font(.system(size: 12))
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: colorScheme == .dark ? .secondarySystemBackground : .systemBackground)).shadow(radius: 5))
    }
}

struct JobPreview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            JobPreview(job: Job.data)
                .previewLayout(.sizeThatFits)
            
            JobPreview(job: Job.data)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
