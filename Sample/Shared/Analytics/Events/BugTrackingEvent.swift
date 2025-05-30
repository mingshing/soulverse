//
//  BugTrackingEvent.swift
//  KonoSummit
//
//  Created by Kono on 2023/8/1.
//

import Foundation

struct BugTrackingEvent: TrackingEventType {
    
    var category: String
    var name: String
    var metadata: [String : Any]
    
    private init(name: String, metadata: [String: Any] = [:]) {
        self.name = name
        self.metadata = metadata
        self.category = "BugTracking"
    }
}
