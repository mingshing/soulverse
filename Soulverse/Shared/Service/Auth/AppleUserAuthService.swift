//
//  AppleUserAuthService.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/6.
//

import Foundation
import AuthenticationServices

class AppleUserAuthService: NSObject, AuthService {
    
    var completionAction: ((AuthResult)->Void)?
    let platform: String = "apple"
    
    func signup(_ completion: ((AuthResult)->Void)? = nil) {
        login(completion)
    }
    
    func login(_ completion: ((AuthResult)->Void)? = nil) {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
        completionAction = completion
    }
}

extension AppleUserAuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            if let token = credential.identityToken {
                
                UserService.login(account: credential.user, validator: Utility.base64Encode(token), platform: platform) { [weak self] result in
                    guard let weakSelf = self else { return }
                
                    switch result {
                    case let .success(response):
                        weakSelf.completionAction?(.AuthLoginSuccess)
                    case let .failure(error):
                        weakSelf.completionAction?(error.reason)
                    }
                }
            }
        }
    }
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        completionAction?(.ThirdPartyServiceError(errorMsg: error.localizedDescription))
    }
    
    
}
