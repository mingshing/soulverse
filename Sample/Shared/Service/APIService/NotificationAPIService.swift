//
//  NotificationAPIService.swift
//
//
import Foundation
import Moya

let NotificationAPIServiceProvider = MoyaProvider<NotificationAPIService>()
//let NotificationAPIServiceProvider = MoyaProvider<NotificationAPIService>(stubClosure: MoyaProvider.delayedStub(0.2))

enum NotificationAPIService {
    
    case getNotificationItems(beginTime: TimeInterval)
    case updateNotificationReadTime

}

extension NotificationAPIService: TargetType {
    
    var baseURL: URL {
        return URL(string: HostAppContants.serverUrl)!
    }
    
    var path: String {
        switch self {
        case .getNotificationItems:
            return "notifications"
        case .updateNotificationReadTime:
            return "notification_last_view_time"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNotificationItems:
            return .get
        case .updateNotificationReadTime:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getNotificationItems:
            guard let url = Bundle.main.url(forResource: "NotificationResponse", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                        return Data()
                    }
            return data
        case .updateNotificationReadTime:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .getNotificationItems(let beginTime):
            if beginTime == 0 {
                return .requestPlain
            }
            return .requestParameters(parameters: ["lasttimestamp": beginTime], encoding: URLEncoding.queryString)
        case .updateNotificationReadTime:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
