//
//  NotificationPresenterType.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/14.
//

import Foundation

enum NotificationFetchStatus: Equatable {
    case inital
    case fetching
    case partialFetched
    case allFetched
    case unauthorized
    case unknownError
}

protocol NotificationPresenterDelegate: AnyObject {
    
    func didUpdateViewModel(viewModel: NotificationViewModel)
}


protocol NotificationPresenterType: AnyObject {
    
    var viewModel: NotificationViewModel {get set}
    var delegate: NotificationPresenterDelegate? {get set}
    var hasAskPermission: Bool {get set}
    
    func fetchData(completion: (()->Void)?)
    func loadNext(completion: (()->Void)?)
    func updateNotificationReadStatus()
    func numberOfItems() -> Int
    func viewModelForIndex(_ row: Int) -> NotificationItemCellViewModel?
    
    func askNotificationPermission()
}
