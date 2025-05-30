//
//  KonoUserAuthService.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/6.
//

import Foundation

class KonoUserAuthService: AuthService {

        
    var account: String?
    var validator: String?
    let platform: String = "kono"
    
    init(email: String, password: String) {
        
        self.account = email
        self.validator = password

    }
    func login(_ completion: ((AuthResult)->Void)? = nil) {
        guard let account = account,
              let validator = validator else { return }
        
        UserService.login(account: account, validator: validator, platform: platform) { result in
            switch result {
            case let .success(response):
                completion?(.AuthLoginSuccess)
            case let .failure(error):
                completion?(error.reason)
            }
        }
    }
    
    func signup(_ completion: ((AuthResult)->Void)? = nil) {
        
        guard let account = account,
              let validator = validator else { return }
        UserService.signup(account: account, password: validator, platform: platform) { result in
            switch result {
            case let .success(response):
                completion?(.AuthSignupSuccess)
            case let .failure(error):
                completion?(error.reason)
            }
        }
    }
    
}
