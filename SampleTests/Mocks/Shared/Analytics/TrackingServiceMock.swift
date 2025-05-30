//
//  TrackingServiceMock.swift
//
//

import Foundation
@testable import Sample

final class TrackingServiceMock: TrackingServiceType {
    
    var trackedEvent: TrackingEventType?
    var trackedUserId: String?
    var trackedUserEmail: String?
    var trackedUserRegisterChannel: String?
    var saveUserPropertyValue: String? = "testUserProperty"
    
    func clearUserProperties() {
        saveUserPropertyValue = nil
    }
    
    func setupUserDefaultProperties(_ user: UserProtocol) {
        trackedUserId = user.userId
        trackedUserEmail = user.email
        trackedUserRegisterChannel = user.registerChannel
    }

    func track(_ event: TrackingEventType) {
        trackedEvent = event
    }
    
}
