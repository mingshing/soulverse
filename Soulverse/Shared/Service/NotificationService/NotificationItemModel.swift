//
//  NotificationItemModel.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/15.
//

import Foundation

enum NotificationType: String, Equatable {
    
    case book = "book"
    case externalLink = "external_link"
    case unknown
}


struct NotificationItemModel {
    
    enum CodingKeys: String, CodingKey {
        case notificationId, title, body, image, status, type, payload, createdAt
        
    }
    
    var notificationId: String
    var title: String
    var body: String
    var image: String
    var status: Int
    var type: NotificationType
    var createdAt: TimeInterval
    var notificationPayload: [String: Any]?

    var actionId: String?
}

extension NotificationItemModel: Decodable {
    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        notificationId = try container.decode(String.self, forKey: .notificationId)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        image = try container.decode(String.self, forKey: .image)
        status = try container.decode(Int.self, forKey: .status)
        let typeStr = try container.decode(String.self, forKey: .type)
        type = NotificationType(rawValue: typeStr) ?? .unknown
        createdAt = try container.decode(TimeInterval.self, forKey: .createdAt)
        notificationPayload = try container.decodeIfPresent([String: Any].self, forKey: .payload)
        
        if let payload = notificationPayload {
            
            if type == .book {
                actionId = payload["pcontentId"] as? String
            } else {
                actionId = payload["URL"] as? String
            }
        }
    }
}
