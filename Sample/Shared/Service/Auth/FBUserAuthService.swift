//
//  FBUserAuthService.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/6.
//

import Foundation
import FBSDKLoginKit

class FBUserAuthService: AuthService {
    
    let platform: String = "facebook"
    let loginManager = LoginManager()
    
    
    func signup(_ completion: ((AuthResult)->Void)? = nil) {
        login(completion)
    }
    
    func login(_ completion: ((AuthResult)->Void)? = nil) {
        loginManager.logOut()
        
        let configuration = LoginConfiguration.init(permissions: ["public_profile", "email"], tracking: .limited)
        loginManager.logIn(configuration: configuration) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success:
                guard let userID = Profile.current?.userID,
                      let tokenString = AuthenticationToken.current?.tokenString else {
                    completion?(.ThirdPartyServiceError(errorMsg: "nil token"))
                    return
                }
                
                UserService.login(account: userID, validator: tokenString, platform: weakSelf.platform) { result in
                    switch result {
                    case .success(let response):
                        //FIXME: response picture is empty? (fb limit login 2025.04)
                            
                        completion?(.AuthLoginSuccess)
                    case .failure(let error):
                        print(error)
                        completion?(.ThirdPartyServiceError(errorMsg: error.localizedDescription))
                    }
                }
                
            case .failed(let error):
                completion?(.ThirdPartyServiceError(errorMsg: error.localizedDescription))
            case .cancelled:
                completion?(.UserCancel)
            }
        }
    }
}
