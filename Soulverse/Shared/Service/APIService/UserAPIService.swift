//
//  UserAPIService.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/8.
//
import Foundation
import Moya

let UserAPIServiceProvider = MoyaProvider<UserAPIService>()
                                                                                   
enum UserAPIService {
    
    case signup(account: String, password: String, platform: String)
    case login(account: String, validator: String, platform: String)
    case remindPassword(account: String)
    case sendVerifyEmail(userId: String)
    case getProfile(userId: String)
    case updateFCMToken(token: String)
    case changePassword(userId: String, oldPassword: String, newPassword: String)

}

extension UserAPIService: TargetType {
    var baseURL: URL {
        return URL(string: HostAppContants.serverUrl)!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "users"
        case .login:
            return "users/login"
        case .remindPassword:
            return "users/remind_password"
        case .sendVerifyEmail(let userId):
            return "users/\(userId)/request_confirmations"
        case .getProfile:
            return "me"
        case .updateFCMToken:
            return "pushtokens"
        case .changePassword(let userId, _, _):
            return "users/\(userId)/change_password"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup, .login, .remindPassword, .sendVerifyEmail, .changePassword:
            return .post
        case .getProfile:
            return .get
        case .updateFCMToken:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(let account, let validator, let platform),
             .signup(let account, let validator, let platform):
            return .requestParameters(parameters: ["platform": platform, "account": account, "validator": validator, "service": "summit"], encoding: JSONEncoding.default)
        case .remindPassword(let account):
            return .requestParameters(parameters: ["account": account], encoding: JSONEncoding.default)
        case .updateFCMToken(let token):
            return .requestParameters(parameters: ["token": token], encoding: JSONEncoding.default)
        case .changePassword(_ , let oldPassword, let newPassword):
            return .requestParameters(parameters: ["old_password": oldPassword, "new_password": newPassword], encoding: JSONEncoding.default)
        case .sendVerifyEmail(_), .getProfile(_):
            return .requestPlain
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
