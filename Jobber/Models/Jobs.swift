//
//  Jobs.swift
//  Jobber
//
//  Created by Matteo on 07/04/2022.
//

import Foundation

struct Jobs: Decodable {
    let resultats: [Job]?
}

struct Job: Decodable, Identifiable {
    let id: String
    let intitule: String
    let description: String
    let lieuTravail: String
    let entreprise: Company
    let typeContrat: String
    let typeContratLibelle: String
    let experienceLibelle: String
    let salaire: Wage
    let dureeTravailLibelleConverti: String
    let origineOffre: Origin
    
    init(id: String, intitule: String, description: String?, lieuTravail: Location?, entreprise: Company?, typeContrat: String?, typeContratLibelle: String?, experienceLibelle: String?, salaire: Wage?, dureeTravailLibelleConverti: String?, origineOffre: Origin?) {
        self.id = id
        self.intitule = intitule.trimmingCharacters(in: .whitespacesAndNewlines)
        self.description = description ?? ""
        
        if let location = lieuTravail?.libelle?.split(separator: "-") {
            if (location.count > 1) {
                self.lieuTravail = "\(location[1].capitalized) (\(location[0].trimmingCharacters(in: .whitespacesAndNewlines)))"
            } else {
                self.lieuTravail = "\(location[0])"
            }
        } else {
            self.lieuTravail = "Non précisé"
        }
        self.entreprise = Company(nom: entreprise?.nom ?? "Non précisé", description: entreprise?.description)
        self.typeContrat = typeContrat ?? "Non précisé"
        self.typeContratLibelle = typeContratLibelle ?? "Non précisé"
        self.experienceLibelle = experienceLibelle ?? "Non précisé"
        
        var formatedWage = "Salaire non précisé"
        if let wage = salaire?.libelle?.split(separator: " ") {
            if wage[0] == "Horaire" {
                formatedWage = "\(wage[2]) € de l'heure"
            } else if wage[0] == "Mensuel" {
                if wage.count > 7 {
                    formatedWage = "\(wage[2]) € - \(wage[5]) € par mois"
                } else {
                    formatedWage = "\(wage[2]) € par mois"
                }
            } else if wage[0] == "Annuel" {
                if wage.count > 7 {
                    formatedWage = "\(wage[2]) € - \(wage[5]) € par an"
                } else {
                    formatedWage = "\(wage[2]) € par an"
                }
            }
        }
        self.salaire = Wage(libelle: formatedWage, commentaire: salaire?.commentaire)
        self.dureeTravailLibelleConverti = dureeTravailLibelleConverti ?? "Non précisé"
        self.origineOffre = Origin(urlOrigine: origineOffre?.urlOrigine ?? "https://candidat.pole-emploi.fr/offres/recherche/detail/\(id)")
    }
}

extension Job {
    
    enum CodingKeys: String, CodingKey {
        case id
        case intitule
        case description
        case lieuTravail
        case entreprise
        case typeContrat
        case typeContratLibelle
        case experienceLibelle
        case salaire
        case dureeTravailLibelleConverti
        case origineOffre
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let intitule = try container.decode(String.self, forKey: .intitule)
        let description = try container.decodeIfPresent(String.self, forKey: .description)
        let lieuTravail = try container.decodeIfPresent(Location.self, forKey: .lieuTravail)
        let entreprise = try container.decodeIfPresent(Company.self, forKey: .entreprise)
        let typeContrat = try container.decodeIfPresent(String.self, forKey: .typeContrat)
        let typeContratLibelle = try container.decodeIfPresent(String.self, forKey: .typeContratLibelle)
        let experienceLibelle = try container.decodeIfPresent(String.self, forKey: .experienceLibelle)
        let salaire = try container.decodeIfPresent(Wage.self, forKey: .salaire)
        let dureeTravailLibelleConverti = try container.decodeIfPresent(String.self, forKey: .dureeTravailLibelleConverti)
        let origineOffre = try container.decodeIfPresent(Origin.self, forKey: .origineOffre)
        
        self.init(id: id, intitule: intitule, description: description, lieuTravail: lieuTravail, entreprise: entreprise, typeContrat: typeContrat, typeContratLibelle: typeContratLibelle, experienceLibelle: experienceLibelle, salaire: salaire, dureeTravailLibelleConverti: dureeTravailLibelleConverti, origineOffre: origineOffre)
    }
}

struct Location: Decodable {
    let libelle: String?
}

struct Company: Codable {
    let nom: String?
    let description: String?
}

struct Wage: Codable {
    let libelle: String?
    let commentaire: String?
}

struct Origin: Codable {
    let urlOrigine: String?
}


extension Job {
    static var data: Job = Job(id: "1", intitule: "Manager en restauration rapide  (H/F)", description: "La société Burger King recherche un manager F/H en CDI Temps plein.\n\nVos missions seront : \n-Réaliser les objectifs de chiffre d'affaires en garantissant la qualité du service\nclient : accueil, fabrication produit, rapidité de service, entretien du restaurant.\n-Animer, former, accompagner, briefer une équipe de 10 à 15 personnes\nminimum et apportez votre expertise pour optimiser leur performance.\n-Assurer la gestion quotidienne des approvisionnements, des stocks et de la\nproduction afin de proposer le meilleur produit à vos clients.\n-Développer les domaines d'expertise du centre de profit (développement du CA,\nmanagement d'équipe, rentabilité financière)\"\t\t\t\t\t\n\t\t\t\t\t\n\"Vous aimez être dans le feu de l'action, vous savez tirer le meilleur de vos équipes et, après\nune première expérience réussie dans le management d'équipe dans la restauration ou le\ncommerce, vous brûlez de faire vos preuves dans une entreprise en pleine croissance.\nUne formation de 9 semaines vous sera dispensée.\n\nLe poste est à pourvoir à l'occasion d'un événement de recrutement qui se déroulera le mardi 19 Avril à Montauban à partir de 18h30. La société WIZBII est en charge de la présélection des candidats.", lieuTravail: Location(libelle: "82 - MONTAUBAN"), entreprise: Company(nom: "WIZBII", description: "\"Fondée en 1954, BURGER KING® est la seconde chaîne de burger au monde. BURGER KING®\nest présent dans plus de 100 pays avec plus de 17 000 restaurants."), typeContrat: "CDI", typeContratLibelle: "Contrat à durée indéterminée", experienceLibelle: "Débutant accepté", salaire: Wage(libelle: "Mensuel de 1700,00 Euros à 2000,00 Euros sur 12 mois", commentaire: nil), dureeTravailLibelleConverti: "Temps plein", origineOffre: Origin(urlOrigine: "https://candidat.pole-emploi.fr/offres/recherche/detail/131LTQD"))
}
