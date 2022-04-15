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
    static let client_id = "PAR_jobber_a4e1540e65865a3c7ebe590c4d77f745036856c323e894d7324c5361e41e8e80"
    static let client_secret = "ac2a5a23b07ef1493d0936f9489069cc120797226cdcc0c73f420e63c7046c3b"
    static let scope = "application_PAR_jobber_a4e1540e65865a3c7ebe590c4d77f745036856c323e894d7324c5361e41e8e80 api_offresdemploiv2 o2dsoffre"
}
