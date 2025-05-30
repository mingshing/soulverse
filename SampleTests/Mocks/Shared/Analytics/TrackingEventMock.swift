//
//  TrackingEventMock.swift
//
//  Created by mingshing on 2022/1/4.
//

import Foundation
@testable import Sample

class TrackingEventMock: TrackingEventType {
    
    var category: String
    var name: String
    var metadata: [String : Any]
    
    init(_ eventName: String, eventProperties: [String: Any]) {
        category = "Test"
        name = eventName
        metadata = eventProperties
    }
}
