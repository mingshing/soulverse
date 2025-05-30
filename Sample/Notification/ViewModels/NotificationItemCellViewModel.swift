//
//  NotificationCellViewModel.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/14.
//

import Foundation
import DateToolsSwift

class NotificationItemCellViewModel {
 
    let notification: NotificationItemModel
    var hasRead: Bool
    
    init (notification: NotificationItemModel) {
        self.notification = notification
        self.hasRead = notification.status == 1
    }
    
    var title: String {
        return notification.title
    }
    
    var description: String {
        return notification.body
    }
    
    var mainImageURL: String {
        return notification.image
    }
    
    var createdTime: TimeInterval {
        return notification.createdAt
    }
    
    var createTimeString: String {
        let createdTimeInSecond = createdTime / 1000.0
        let date = Date.init(timeIntervalSince1970: createdTimeInSecond)

        return date.timeAgoSinceNow
    }
    
    var type: NotificationType {
        return notification.type
    }
    
    var actionId: String? {
        return notification.actionId
    }
}
