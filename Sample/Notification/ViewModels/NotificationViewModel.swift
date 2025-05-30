//
//  NotificationViewModel.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/14.
//

import Foundation

class NotificationViewModel {
    
    var cellViewModels = [NotificationItemCellViewModel]()
    var status: NotificationFetchStatus = .inital
    var hasUnreadNotification: Bool {
        for cellViewModel in cellViewModels {
            if cellViewModel.hasRead == false {
                return true
            }
        }
        return false
    }
    var isEmpty: Bool {
        return cellViewModels.count == 0
    }
    
    public func addNotificationItems(_ data: NotificationItemsResponse) -> Int {
 
        let viewModels = data.notifications.map({ item in
            NotificationItemCellViewModel(notification: item)
        })
        
        cellViewModels.append(contentsOf: viewModels)
        return viewModels.count
        
    }
    
    public func clearUnreadStatus() {
        
        for i in 0..<cellViewModels.count {
            cellViewModels[i].hasRead = true
        }
    }
    
    public func clearFetchedData() {
        status = .inital
        cellViewModels.removeAll()
    }
}
