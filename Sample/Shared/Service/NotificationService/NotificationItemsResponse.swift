//
//  NotificationItemsResponse.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/15.
//

import Foundation

struct NotificationItemsResponse {
    
    enum CodingKeys: String, CodingKey {
        case notifications, unreadCount
    }
    
    var notifications: [NotificationItemModel]
    var unreadCount: Int?
}

extension NotificationItemsResponse: Decodable {
    
    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        notifications = try container.decode([NotificationItemModel].self, forKey: .notifications)
        unreadCount = try container.decodeIfPresent(Int.self, forKey: .unreadCount)
    }
    
}
