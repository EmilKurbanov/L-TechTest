//
//   AuthorizationProtocols.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import Foundation
protocol AuthorizationBusinessLogic {
    func fetchPhoneMask()
    func signIn(phone: String, password: String)
}

protocol AuthorizationInteractorOutput: AnyObject {
    func didFetchPhoneMask(_ mask: String)
    func didSignIn(success: Bool, error: String?)
}


protocol AuthorizationViewControllerProtocol: AnyObject {
    func displayPhoneMask(_ mask: String)
    func displaySignInResult(success: Bool, error: String?)
}

protocol AuthorizationRoutingLogic {
    func routeToMainScreen()
}
