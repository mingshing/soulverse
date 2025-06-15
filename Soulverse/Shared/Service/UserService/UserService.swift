//
//  UserService.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/8.
//
import Foundation
import AVFoundation

enum ApiError: Error, Equatable {
    case UnAuthorize
    case Network
    case ServerError(reason: String)
    case FailedAction(reason: String)
    
    var description: String {
        switch self {
        case .UnAuthorize:
            return "please login"
        case .Network:
            return NSLocalizedString("message_error_network", comment: "")
        case .ServerError(let reason), .FailedAction(let reason):
            return reason
        }
    }
    
}


enum UserServiceError: String, Swift.Error {
    
    case ParameterMissing = "PARAMETER_MISSING"
    case InvalidData = "INVALID_DATA"
    case FacebookAuthError = "FACEBOOK_AUTH_ERROR"
    case AppleAuthError = "APPLE_AUTH_ERROR"
    case EmailNotFound = "EMAIL_NOT_FOUND"
    case PasswordError = "PASSWORD_ERROR"
    case Network = "NETWORK"
    
    //MARK: sign up specific
    case EmailNotUnique = "EMAIL_NOT_UNIQUE"
    case BadEmail = "BAD_EMAIL"
    
    
    //MARK: resend email specific
    case EmailConfirmed = "User was email confirmed"
    case EmailBlank = "User's email is blank"
    
    var reason: AuthResult {
        switch self {
        case .EmailNotFound, .PasswordError:
            return .InputDataInvalid
        case .InvalidData, .ParameterMissing, .EmailConfirmed, .EmailBlank:
            return .ServerError
        case .FacebookAuthError, .AppleAuthError:
            return .ThirdPartyServiceError(errorMsg: nil)
        case .Network:
            return .NetworkError
        case .EmailNotUnique:
            return .EmailNotUnique
        case .BadEmail:
            return .BadEmail
        }
    }
    
}


class UserService {
    
    public static func login(account: String, validator: String, platform: String, completion: @escaping(Result<SummitUserModel, UserServiceError>) -> ()) {
        
        UserAPIServiceProvider.request(.login(account: account, validator: validator, platform: platform)) { result in
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusAndRedirectCodes()
                    var result = try JSONDecoder().decode(SummitUserModel.self, from: filteredResponse.data)
                    
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.response?.allHeaderFields as! [String: String], for: (response.response?.url)!)
                    if let sessionToken = cookies.first(where: { cookie in
                        cookie.name == HostAppContants.sessionKey
                    }) {
                        result.sessionToken = sessionToken.value
                    }
                    
                    completion(.success(result))
                } catch _ {
                   
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers)
                        let dic = json as! Dictionary<String, Any>
                        if dic.keys.contains("code") {
                            let error = UserServiceError(rawValue: dic["code"] as! String)
                            completion(.failure(error ?? UserServiceError.InvalidData))
                        } else {
                            completion(.failure(UserServiceError.InvalidData))
                        }
                        
                    } catch _ {
                        completion(.failure(UserServiceError.InvalidData))
                    }
                }
            case .failure(_):
                completion(.failure(UserServiceError.Network))
            }
        }
    }
    
    public static func signup(account: String, password: String, platform: String, completion: @escaping(Result<SummitUserModel, UserServiceError>) -> ()) {
        
        UserAPIServiceProvider.request(.signup(account: account, password: password, platform: platform)) { result in
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusAndRedirectCodes()
                    let result = try JSONDecoder().decode(SummitUserModel.self, from: filteredResponse.data)
                    
                    
                    completion(.success(result))
                } catch _ {
                   
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers)
                        let dic = json as! Dictionary<String, Any>
                        if dic.keys.contains("code") {
                            let error = UserServiceError(rawValue: dic["code"] as! String)
                            completion(.failure(error ?? UserServiceError.InvalidData))
                        } else {
                            completion(.failure(UserServiceError.InvalidData))
                        }
                        
                    } catch _ {
                        completion(.failure(UserServiceError.InvalidData))
                    }
                }
            case .failure(_):
                completion(.failure(UserServiceError.Network))
            }
        }
    }
    
    public static func remindPassword(account: String, completion: @escaping(Result<String, UserServiceError>) -> ()) {
        
        UserAPIServiceProvider.request(.remindPassword(account: account)) { result in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                
                if statusCode == 200 {
                    completion(.success(account))
                } else if statusCode == 403 {
                    completion(.failure(.InvalidData))
                } else if statusCode == 404 {
                    completion(.failure(.EmailNotFound))
                } else if statusCode == 500 {
                    completion(.failure(.Network))
                }
            case .failure(_):
                completion(.failure(.Network))
            }
        }
    }
    
    public static func sendVerifyEmail(userId: String, completion: @escaping(Result<String, UserServiceError>) -> ()) {
        
        UserAPIServiceProvider.request(.sendVerifyEmail(userId: userId)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                
                if statusCode == 200 {
                    completion(.success("success"))
                } else if statusCode == 403 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers)
                        let dic = json as! Dictionary<String, Any>
                        if dic.keys.contains("reason") {
                            let error = UserServiceError(rawValue: dic["reason"] as! String)
                            completion(.failure(error ?? UserServiceError.InvalidData))
                        } else {
                            completion(.failure(UserServiceError.InvalidData))
                        }
                    } catch _ {
                        completion(.failure(UserServiceError.InvalidData))
                    }
                } else {
                    
                    print(String(decoding: response.data, as: UTF8.self))
                    completion(.failure(UserServiceError.InvalidData))
                }
            case .failure(_):
                completion(.failure(UserServiceError.Network))
            }
        }
    }
    
    public static func updateUserProfile(userId: String, completion: @escaping(Result<SummitUserModel, ApiError>) -> ()) {
        
        UserAPIServiceProvider.request(.getProfile(userId: userId)) { result in
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusAndRedirectCodes()
                    let result = try JSONDecoder().decode(SummitUserModel.self, from: filteredResponse.data)
                    
                    completion(.success(result))
                } catch _ {
                    
                    let errorResponse = String(decoding: response.data, as: UTF8.self)
                    print("[API Error: \(#function)] \(errorResponse)")
                    
                    switch response.statusCode {
                    case 401:
                        completion(.failure(ApiError.UnAuthorize))
                    default:
                        completion(.failure(ApiError.ServerError(reason: errorResponse)))
                    }
                    
                }
            case .failure(let error):
                print(error.errorDescription ?? "")
                completion(.failure(ApiError.Network))
            }
        }
    }
    
    public static func updateFCMToken(token: String, completion: @escaping(Result<String, ApiError>) -> ()) {
    
        UserAPIServiceProvider.request(.updateFCMToken(token: token)) { result in
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusAndRedirectCodes()
                    let result = String(decoding: filteredResponse.data, as: UTF8.self)
                    
                    completion(.success(result))
                } catch _ {
                    
                    let errorResponse = String(decoding: response.data, as: UTF8.self)
                    print("[API Error: \(#function)] \(errorResponse)")
                    completion(.failure(ApiError.ServerError(reason: errorResponse)))
                }
            case .failure(let error):
                print(error.errorDescription ?? "")
                completion(.failure(ApiError.Network))
            }
        }
    }
    
    public static func changePassword(userId: String, oldPassword: String, newPassword: String, completion: @escaping(Result<String, ApiError>) -> ()) {
    
        UserAPIServiceProvider.request(.changePassword(userId: userId, oldPassword: oldPassword, newPassword: newPassword)) { result in
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusAndRedirectCodes()
                    let result = String(decoding: filteredResponse.data, as: UTF8.self)
                    
                    completion(.success(result))
                } catch _ {
                    
                    let errorResponse = String(decoding: response.data, as: UTF8.self)
                    print("[API Error: \(#function)] \(errorResponse)")
                    switch response.statusCode {
                    case 401:
                        completion(.failure(ApiError.FailedAction(reason: errorResponse)))
                    default:
                        completion(.failure(ApiError.ServerError(reason: errorResponse)))
                    }
                    
                }
            case .failure(let error):
                print(error.errorDescription ?? "")
                completion(.failure(ApiError.Network))
            }
        }
    }
}
