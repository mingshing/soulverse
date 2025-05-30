//
//  GeneralEvent.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/21.
//

import Foundation


enum AccountEvent: TrackingEventType {
    
    //MARK: behavior event
    case clickBack
    case clickSkip
    case clickSwitch(from: LoginViewDisplayMode, to: LoginViewDisplayMode)
    case clickPolicy
    case clickForgetPassword
    case clickRegister(platform: LoginPlatform)
    case clickLogin(platform: LoginPlatform)
    
    //MARK: status event
    case logIn(platform: LoginPlatform)
    case logOut
    case signUp(platform: LoginPlatform)
    
    case error(reason: String, platform: LoginPlatform)
    
    //MARK: page view event
    case viewRegisterPage(source: AppLocation)
    
    var category: String {
        return "Account"
    }
    
    var name: String {
        switch self {
        case .clickBack:
            return "click back"
        case .clickSkip:
            return "click skip"
        case .clickSwitch(_, _):
            return "click switch"
        case .clickPolicy:
            return "click policy"
        case .clickRegister:
            return "click register"
        case .clickLogin:
            return "click login"
        case .clickForgetPassword:
            return "click forget password"
        case .logIn(_):
            return "log in"
        case .logOut:
            return "log out"
        case .signUp(_):
            return "sign up"
        case .error(_,_):
            return "auth error"
        case .viewRegisterPage(_):
            return "view register page"
        }
    }
    
    var metadata: [String : Any] {
        switch self {
        case .clickLogin(let platform), .clickRegister(let platform):
            return [TrackingUserProperty.accountType: platform.name]
        case .logIn(let platform), .signUp(let platform):
            return [TrackingUserProperty.accountType: platform.name]
        case .clickSwitch(_, let targetMode):
            return ["target mode": targetMode.name]
        case .error(let reason, let platform):
            return [TrackingUserProperty.accountType: platform.name,
                    "description": reason]
        case .viewRegisterPage(let source):
            return ["source": source.rawValue]
        default:
            return [:]
        }
    }

}
