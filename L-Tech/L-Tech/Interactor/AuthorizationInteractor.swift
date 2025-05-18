//
//  AuthorizationInteractor.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import Foundation
final class AuthorizationInteractor: AuthorizationBusinessLogic {
    weak var output: AuthorizationInteractorOutput?

    func fetchPhoneMask() {
        API.fetchPhoneMask { [weak self] result in
            switch result {
            case .success(let mask):
                self?.output?.didFetchPhoneMask(mask)
            case .failure(let error):
                self?.output?.didSignIn(success: false, error: "Ошибка загрузки маски: \(error)")
            }
        }
    }

    func signIn(phone: String, password: String) {
        print("Interactor: signIn called with phone: \(phone), password: \(password)")
        API.signIn(phone: phone, password: password) { [weak self] result in
            switch result {
            case .success(let response):
                print("Interactor: signIn success = \(response.success)")
                self?.output?.didSignIn(success: response.success, error: response.success ? nil : "Неверный логин или пароль")
            case .failure(let error):
                print("Interactor: signIn failed with error \(error)")
                self?.output?.didSignIn(success: false, error: error.localizedDescription)
            }
        }
    }

}

