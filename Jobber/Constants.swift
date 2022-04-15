//
//  Constants.swift
//  Jobber
//
//  Created by Matteo on 07/04/2022.
//

import Foundation

let kAPIAccessTokenURL = "https://entreprise.pole-emploi.fr/connexion/oauth2/access_token?realm=/partenaire"

enum Credentials {
    static let grant_type = "client_credentials"
    static let client_id = "XXXXXXX" // Your Pôle-emploi client ID
    static let client_secret = "XXXXXXX" // Your Pôle-emploi client secret
    static let scope = "application_[YOUR_CLIENT_ID] api_offresdemploiv2 o2dsoffre"
}
