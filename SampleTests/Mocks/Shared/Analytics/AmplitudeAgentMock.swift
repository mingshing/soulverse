//
//  AmplitudeAgentMock.swift
//  KonoSummitTests
//
//  Created by mingshing on 2022/1/4.
//

import Foundation
import Amplitude_iOS

@objc class AmplitudeAgentMock: Amplitude {
    
    var testUserId: String?
    var testUserProperties: [AnyHashable : Any]?
    var testEvent: String?
    var testEventProperties: [AnyHashable : Any]?
    
    override func setUserId(_ userId: String!){
        testUserId = userId
    }
    
    override func setUserProperties(_ userProperties: [AnyHashable : Any]!) {
        testUserProperties = userProperties
    }
    
    override func logEvent(_ eventType: String!) {
        testEvent = eventType
    }
    
    override func logEvent(_ eventType: String!, withEventProperties eventProperties: [AnyHashable : Any]!) {
        testEvent = eventType
        testEventProperties = eventProperties
    }
}
