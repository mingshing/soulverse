//
//  NotificationService.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/15.
//

import Foundation

class NotificationService {
    
    public static func getNotificationItems(for userId: String, from time: TimeInterval = 0, completion: @escaping(String, Result<NotificationItemsResponse, ApiError>) -> ()) {
        
        
        NotificationAPIServiceProvider.request(.getNotificationItems(beginTime: time)) { result in
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusAndRedirectCodes()
                    let result = try JSONDecoder().decode(NotificationItemsResponse.self, from: filteredResponse.data)
                    
                    completion(userId, .success(result))
                } catch _ {
                    
                    let errorResponse = String(decoding: response.data, as: UTF8.self)
                    print("[API Error: \(#function)] \(errorResponse)")
                    
                    switch response.statusCode {
                    case 401:
                        completion(userId, .failure(ApiError.UnAuthorize))
                    default:
                        completion(userId, .failure(ApiError.ServerError(reason: errorResponse)))
                    }
                }
            case .failure(_):
                completion(userId, .failure(ApiError.Network))
            }
        }
    }
    
    public static func updateNotificationReadTime(_ completion: @escaping(Result<String, ApiError>) -> ()) {
        
        NotificationAPIServiceProvider.request(.updateNotificationReadTime) { result in
            switch result {
            case let .success(response):
                let responseStr = String(decoding: response.data, as: UTF8.self)
                
                do {
                    let _ = try response.filterSuccessfulStatusAndRedirectCodes()
                    
                    completion(.success(responseStr))
                } catch _ {
                    
                    
                    print("[API Error: \(#function)] \(responseStr)")
                    
                    switch response.statusCode {
                    case 401:
                        completion(.failure(ApiError.UnAuthorize))
                    default:
                        completion(.failure(ApiError.ServerError(reason: responseStr)))
                    }
                }
            case .failure(_):
                completion(.failure(ApiError.Network))
            }
        }
    }
    
}
