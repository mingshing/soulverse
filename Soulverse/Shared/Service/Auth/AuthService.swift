//
//  AuthService.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/6.
//

import Foundation

enum AuthResult {
    
    case AuthLoginSuccess
    case AuthSignupSuccess
    case InputDataInvalid
    case ThirdPartyServiceError(errorMsg: String? = nil)
    case ServerError
    case BadEmail
    case EmailNotUnique
    case NetworkError
    case UserCancel
    case UnknownError
    
    var description: String {
        switch self {
        case .AuthLoginSuccess:
            return "success login"
        case .AuthSignupSuccess:
            return "success sign up"
        case .InputDataInvalid:
            return "input invalid"
        case .ThirdPartyServiceError(_):
            return "third party service error"
        case .ServerError:
            return "our server error"
        case .BadEmail:
            return "bad email"
        case .EmailNotUnique:
            return "account existed"
        case .NetworkError:
            return "network error"
        case .UserCancel:
            return "user cancel the process"
        case .UnknownError:
            return "unknown error"
        }
    }
}


protocol AuthService {
    
    func signup(_ completion: ((AuthResult)->Void)?)
    func login(_ completion: ((AuthResult)->Void)?)
}
