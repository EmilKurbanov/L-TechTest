//
//  AuthorizationRouter.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import UIKit

final class AuthorizationRouter: AuthorizationRoutingLogic {
    weak var viewController: UIViewController?

    func routeToMainScreen() {
        let mainVC = UIViewController()
        mainVC.view.backgroundColor = .systemGreen
        mainVC.title = "Main Screen"
        viewController?.navigationController?.pushViewController(mainVC, animated: true)
    }
}
