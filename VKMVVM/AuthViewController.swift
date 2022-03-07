//
//  AuthViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.12.2021.
//

import UIKit

class AuthViewController: UIViewController {

    private let authButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти в ВК", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ошибка\nПроверьте интернет!"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(authButton)
        view.addSubview(errorLabel)
        authButton.addTarget(self, action: #selector(singIn), for: .touchUpInside)
        NSLayoutConstraint.activate([
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/5),
            authButton.heightAnchor.constraint(equalToConstant: 50),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            errorLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    @objc private func singIn() {
        AuthService.shared.wakeUpSession()
    }
    
    func showError() {
        authButton.isHidden = true
        errorLabel.isHidden = false
    }
}

extension AuthViewController: AuthServiceDelegate {
    func authServiceShouldShow(viewController: UIViewController) {
        print(#function)
        present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        present(NewsFeedViewController(), animated: true, completion: nil)
        print(#function)
    }
    
    func authServiceSignInDidFail() {
        print(#function)
    }
    
    func forceLogout() {
        print(#function)
    }
}
