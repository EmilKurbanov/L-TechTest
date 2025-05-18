//
//  ViewController.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import UIKit
import SnapKit

final class AuthorizationViewController: UIViewController, AuthorizationViewControllerProtocol {

     private let logoImageView = UIImageView()
     private let titleLabel = UILabel()

     private let phoneLabel = UILabel()

     private let passwordLabel = UILabel()
 
     private let signInButton = UIButton(type: .system)
    
    private let phoneTextField = PaddedTextField()
    private let passwordTextField = PaddedTextField()
    
    private let clearButton = UIButton(type: .custom)
    private let togglePasswordButton = UIButton(type: .custom)

    private var interactor: AuthorizationBusinessLogic?
    private var router: AuthorizationRoutingLogic?

    private let keychain = KeychainService.shared
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Неверный пароль"
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSignInButtonState()
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setup()
        setupUI()
        loadSavedCredentials()
        interactor?.fetchPhoneMask()
    }

    private func setup() {
        let interactor = AuthorizationInteractor()
        let presenter = AuthorizationPresenter()
        let router = AuthorizationRouter()

        self.interactor = interactor
        self.router = router

        interactor.output = presenter
        presenter.viewController = self
        router.viewController = self
    }


    private func setupUI() {
        view.backgroundColor = .white
       
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(56)
            make.width.equalTo(130.66665649414062)
            make.height.equalTo(28)
            make.centerX.equalToSuperview()
        }

        // Заголовок "Вход в аккаунт"
        let titleLabel = UILabel()
        titleLabel.text = "Вход в аккаунт"
        titleLabel.font = UIFont(name: "SF Pro Display", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.layer.masksToBounds = true
        titleLabel.snp.makeConstraints { _ in }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }

        
        let phoneLabel = UILabel()
        phoneLabel.text = "Телефон"
        phoneLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        phoneLabel.textColor = .black
        view.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.left.equalToSuperview().inset(20)
        }

      
        phoneTextField.borderStyle = .none
        phoneTextField.keyboardType = .phonePad
        phoneTextField.placeholder = "Phone"
        phoneTextField.layer.cornerRadius = 14
        phoneTextField.layer.borderWidth = 1.5
        phoneTextField.layer.borderColor = UIColor.gray.cgColor
        phoneTextField.setLeftPaddingPoints(10)
        phoneTextField.setRightPaddingPoints(40) 
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.width.equalTo(343).priority(.high)
        }

      
        let clearButton: UIButton
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "xmark.circle.fill")
            config.baseForegroundColor = .gray
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: 8)

            clearButton = UIButton(configuration: config)
        } else {
            clearButton = UIButton(type: .custom)
            clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            clearButton.tintColor = .gray
            clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        }

        clearButton.addTarget(self, action: #selector(clearPhoneTextField), for: .touchUpInside)
        phoneTextField.rightView = clearButton
        phoneTextField.rightViewMode = .whileEditing


        let passwordLabel = UILabel()
        passwordLabel.text = "Пароль"
        passwordLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        passwordLabel.textColor = .black
        
        view.addSubview(passwordLabel)
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(16)
            make.left.equalTo(phoneLabel)
        }
      
        passwordTextField.borderStyle = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.layer.cornerRadius = 14
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.setLeftPaddingPoints(10)
        passwordTextField.setRightPaddingPoints(40)
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.width.equalTo(343).priority(.high)
        }
        view.addSubview(passwordErrorLabel)
           passwordErrorLabel.snp.makeConstraints { make in
               make.top.equalTo(passwordTextField.snp.bottom).offset(4)
               make.left.equalTo(passwordTextField.snp.left).offset(10) 
               make.right.equalTo(passwordTextField.snp.right)
               make.height.equalTo(18)
           }

       
        let eyeButton: UIButton

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "eye.slash")
            config.baseForegroundColor = .gray
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: 8)

            eyeButton = UIButton(configuration: config, primaryAction: nil)
        } else {
            eyeButton = UIButton(type: .custom)
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            eyeButton.tintColor = .gray
            eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        }

        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always

      
        signInButton.setTitle("Войти", for: .normal)
        signInButton.layer.cornerRadius = 16
        signInButton.layer.borderWidth = 1.5
        signInButton.layer.borderColor = UIColor.systemBlue.cgColor
        signInButton.backgroundColor = .systemBlue
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(54)
        }
       

    }

    private func updateSignInButtonState() {
        let isPhoneEmpty = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true

        let shouldEnable = !isPhoneEmpty && !isPasswordEmpty
        signInButton.isEnabled = shouldEnable
        signInButton.alpha = shouldEnable ? 1.0 : 0.5
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSignInButtonState()
    }

    @objc private func clearPhoneTextField() {
        phoneTextField.text = ""
        updateSignInButtonState()
    }

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }



    private func loadSavedCredentials() {
        if let savedPhone = keychain.read(forKey: "userPhone") {
            phoneTextField.text = savedPhone
        }
        if let savedPassword = keychain.read(forKey: "userPassword") {
            passwordTextField.text = savedPassword
        }
        updateSignInButtonState()
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    @objc private func signInTapped() {
        guard let phone = phoneTextField.text, !phone.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert("Введите телефон и пароль")
            return
        }
        
        API.signIn(phone: phone, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.clearPasswordError()
                    self?.keychain.save(phone, forKey: "userPhone")
                    self?.keychain.save(password, forKey: "userPassword")
                    
                    let postsVC = PostsViewController()
                    let nav = UINavigationController(rootViewController: postsVC)
                    nav.modalPresentationStyle = .fullScreen
                    self?.present(nav, animated: true)
                    
                case .failure(_):
                        self?.showPasswordError()
                }
            }
        }
    }


    private func showPasswordError() {
        passwordErrorLabel.isHidden = false
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 1.0
    }

    private func clearPasswordError() {
        passwordErrorLabel.isHidden = true
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 1.0
    }


    // MARK: - AuthorizationViewControllerProtocol

    func displayPhoneMask(_ mask: String) {
        phoneTextField.placeholder = mask
    }

    func displaySignInResult(success: Bool, error: String?) {
        print("ViewController: displaySignInResult success: \(success), error: \(String(describing: error))")
        if success {
            if let phone = phoneTextField.text, let password = passwordTextField.text {
                keychain.save(phone, forKey: "userPhone")
                keychain.save(password, forKey: "userPassword")
            }
            router?.routeToMainScreen()
        } else {
            showAlert(error ?? "Ошибка авторизации")
        }
    }

}




