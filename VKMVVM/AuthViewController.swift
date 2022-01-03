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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        view.addSubview(authButton)
        authButton.addTarget(self, action: #selector(singIn), for: .touchUpInside)
        NSLayoutConstraint.activate([
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/5),
            authButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    @objc private func singIn() {
        AuthService.shared.wakeUpSession()
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
    
    
}
