//
//  User.swift
//

import Foundation
import UIKit

enum UserInfoKeys: String {
    case avatarImageURL
    case email
    case fcmToken
    case hasLoggedIn
    case hasVerified
    case hasGrantedNotification
    case nickname
    case registerChannel
    case nextAskingPermissionTime
    case notificationAskGapTime
    case userId
}

public enum NotificationAskGapTime: Int, Comparable {
    
    case Unknown = 0
    case SevenDays = 1
    case FourteenDays = 2
    case ThirtyDays = 3
    
    var second: Double {
        switch self {
        case .Unknown:
            return 0
        case .SevenDays:
            #if Dev
            return 1 * TimeConstant.miniute
            #else
            return 7 * TimeConstant.day
            #endif
        case .FourteenDays:
            #if Dev
            return 2 * TimeConstant.miniute
            #else
            return 14 * TimeConstant.day
            #endif
        case .ThirtyDays:
            #if Dev
            return 4 * TimeConstant.miniute
            #else
            return 30 * TimeConstant.day
            #endif
        }
    }
    
    public static func < (lhs: NotificationAskGapTime, rhs: NotificationAskGapTime) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}


public protocol UserProtocol {
    var userId: String? { get set }
    var email: String? { get set }
    var registerChannel: String? { get set }
    var isLoggedin: Bool { get }
    var isVerified: Bool { get }
    var hasGrantedNotification: Bool { get }
}

public class User: UserProtocol {
    
    public static let instance = User()
    
    // MARK: - Initializers
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    // MARK: - Properties
    public var userId: String? {
        get {
            let value = defaults.string(forKey: UserInfoKeys.userId.rawValue)
            return value
        }
        set(userId) {
            guard userId != nil else {
                defaults.removeObject(forKey: UserInfoKeys.userId.rawValue)
                return
            }
            defaults.set(userId, forKey: UserInfoKeys.userId.rawValue)
        }
    }
    
    public var email: String? {
        get {
            let value = defaults.string(forKey: UserInfoKeys.email.rawValue)
            return value
        }
        set(newEmail) {
            guard let email = newEmail else {
                defaults.removeObject(forKey: UserInfoKeys.email.rawValue)
                return
            }
            defaults.set(email, forKey: UserInfoKeys.email.rawValue)
        }
    }
    
    public var registerChannel: String? {
        get {
            let value = defaults.string(forKey: UserInfoKeys.registerChannel.rawValue)
            return value
        }
        set(newEmail) {
            guard let email = newEmail else {
                defaults.removeObject(forKey: UserInfoKeys.registerChannel.rawValue)
                return
            }
            defaults.set(email, forKey: UserInfoKeys.registerChannel.rawValue)
        }
    }
    
    var nickName: String? {
        get {
            let value = defaults.string(forKey: UserInfoKeys.nickname.rawValue)
            return value
        }
        set(newNickname) {
            guard let nickname = newNickname else {
                defaults.removeObject(forKey: UserInfoKeys.nickname.rawValue)
                return
            }
            defaults.set(nickname, forKey: UserInfoKeys.nickname.rawValue)
        }
    }
    
    var avatarImageURL: String? {
        get {
            let value = defaults.string(forKey: UserInfoKeys.avatarImageURL.rawValue)
            return value
        }
        set(newImageURL) {
            guard let imageURL = newImageURL else {
                defaults.removeObject(forKey: UserInfoKeys.avatarImageURL.rawValue)
                return
            }
            defaults.set(imageURL, forKey: UserInfoKeys.avatarImageURL.rawValue)
        }
    }
    
    public var isLoggedin: Bool {
        get {
            let res = defaults.bool(forKey: UserInfoKeys.hasLoggedIn.rawValue)
            return res
        }
        set(newValue) {
            defaults.set(newValue, forKey: UserInfoKeys.hasLoggedIn.rawValue)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.UserIdentityChange), object: nil, userInfo: nil)
            updateFCMToken()
        }
    }
    
    public var isVerified: Bool {
        get {
            let res = defaults.bool(forKey: UserInfoKeys.hasVerified.rawValue)
            return res
        }
        set(newValue) {
            defaults.set(newValue, forKey: UserInfoKeys.hasVerified.rawValue)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.UserIdentityChange), object: nil, userInfo: nil)
        }
    }
    
    public var hasGrantedNotification: Bool {
        get {
            let res = defaults.bool(forKey: UserInfoKeys.hasGrantedNotification.rawValue)
            return res
        }
        set(newValue) {
            defaults.set(newValue, forKey: UserInfoKeys.hasGrantedNotification.rawValue)
        }
    }
    
    public var nextAskingPermissionTime: TimeInterval? {
        get {
            let value = defaults.double(forKey: UserInfoKeys.nextAskingPermissionTime.rawValue)
            return value
        }
        set(newAskingTime) {
            guard let _ = newAskingTime else {
                defaults.removeObject(forKey: UserInfoKeys.nextAskingPermissionTime.rawValue)
                return
            }
            defaults.set(newAskingTime, forKey: UserInfoKeys.nextAskingPermissionTime.rawValue)
        }
    }
    
    public var notificationAskGapTime: NotificationAskGapTime {
        get {
            let res = NotificationAskGapTime(rawValue: defaults.integer(forKey: UserInfoKeys.notificationAskGapTime.rawValue)) ?? .Unknown
            return res
        }
        set(newValue) {
            defaults.set(newValue.rawValue, forKey: UserInfoKeys.notificationAskGapTime.rawValue)
        }
    }
    
    public var fcmToken: String? {
        get {
            let value = defaults.string(forKey: UserInfoKeys.fcmToken.rawValue)
            return value
        }
        set(newToken) {
            guard let token = newToken else {
                defaults.removeObject(forKey: UserInfoKeys.fcmToken.rawValue)
                return
            }
            defaults.set(token, forKey: UserInfoKeys.fcmToken.rawValue)
            updateFCMToken()
        }
    }
    
    public func logout() {
        SummitTracker.shared.track(AccountEvent.logOut)
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        clearUserProperty()
    }
    
    private func clearUserProperty() {
        // we won't clear the notification related userdefault
        userId = nil
        email = nil
        isLoggedin = false
        nickName = nil
        avatarImageURL = nil
        isVerified = false
    }
    
    private func updateFCMToken() {
        
        if fcmToken != nil {
            UserService.updateFCMToken(token: fcmToken!) { res in
                switch res {
                case .success(_):
                    print("upload token successfully")
                case .failure(let error):
                    print(error.description)
                }
            }
        }
    }
    
}


// MARK - handle the notification pop up showing logic

extension User {
    
    public func hasShownRequestPermissionAlert() {
        
        var newGapTime: NotificationAskGapTime = .ThirtyDays
        if self.notificationAskGapTime < NotificationAskGapTime.ThirtyDays {
            newGapTime = NotificationAskGapTime(rawValue: notificationAskGapTime.rawValue + 1) ?? .ThirtyDays
        }
        nextAskingPermissionTime = Date().timeIntervalSince1970 + newGapTime.second
        notificationAskGapTime = newGapTime
    }
    
    public func showCustomizeRequestPermissionAlert() -> Bool {
        
        if let nextAskingPermissionTime = nextAskingPermissionTime,
              nextAskingPermissionTime > Date().timeIntervalSince1970 {
            return false
        }
        let cancelAction = SummitAlertAction(
            title: NSLocalizedString("notification_permission_alert_action_later", comment: ""),
            style: .cancel,
            isPreferredAction: false,
            handler: nil)
        
        let okAction = SummitAlertAction(
            title: NSLocalizedString("notification_permission_alert_action_ok", comment: ""),
            style: .default,
            isPreferredAction: true) {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url)
            }
        DispatchQueue.main.async {
            SummitAlertView.shared.show(
                title: NSLocalizedString("notification_permission_alert_title", comment: ""),
                message: NSLocalizedString("notification_permission_alert_description", comment: ""),
                actions: [cancelAction, okAction]
            )
        }
        return true
    }
}
