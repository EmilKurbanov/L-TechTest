//
//  AuthorizationModels.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import Foundation

struct AuthorizationModels {
    struct Request {
        let phone: String
        let password: String
    }

    struct Response {
        let phoneMask: String?
        let success: Bool?
        let errorMessage: String?
    }
}
