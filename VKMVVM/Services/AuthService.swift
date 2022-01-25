//
//  AuthService.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 14.12.2021.
//

import Foundation
import VKSdkFramework

protocol AuthServiceDelegate: AnyObject {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFail()
    func forceLogout()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    private let appId = "8027120"
    private let vkSdk: VKSdk
    
    static let shared: AuthService = AuthService()
    
    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken().accessToken
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["wall","friends"]
        VKSdk.wakeUpSession(scope) { [weak self] state, error in
            switch state {
                case .initialized:
                    VKSdk.authorize(scope)
                case .authorized:
                    self?.delegate?.authServiceSignIn()
                default:
                    self?.delegate?.authServiceSignInDidFail()
            }
        }
    }
    
    func forceLogout() {
        VKSdk.forceLogout()
        delegate?.forceLogout()
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSignInDidFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
}
