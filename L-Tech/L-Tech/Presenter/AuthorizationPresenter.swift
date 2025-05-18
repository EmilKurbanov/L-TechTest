//
//  AuthorizationPresenter.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import UIKit

protocol AuthorizationPresentationLogic {
    func presentPhoneMask(_ mask: String)
    func presentSignInResult(success: Bool, error: String?)
}

final class AuthorizationPresenter: AuthorizationPresentationLogic {
    weak var viewController: AuthorizationViewControllerProtocol?

    func presentPhoneMask(_ mask: String) {
        DispatchQueue.main.async {
            self.viewController?.displayPhoneMask(mask)
        }
    }

    func presentSignInResult(success: Bool, error: String?) {
        DispatchQueue.main.async {
            self.viewController?.displaySignInResult(success: success, error: error)
        }
    }
}

extension AuthorizationPresenter: AuthorizationInteractorOutput {
    func didFetchPhoneMask(_ mask: String) {
        presentPhoneMask(mask)
    }

    func didSignIn(success: Bool, error: String?) {
        print("Presenter: didSignIn success: \(success), error: \(String(describing: error))")
        presentSignInResult(success: success, error: error)
    }
}
