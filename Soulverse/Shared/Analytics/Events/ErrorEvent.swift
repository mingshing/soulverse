//
//  ErrorEvent.swift
//  KonoSummit
//
//  Created by mingshing on 2022/8/14.
//

import Foundation
struct ErrorEvent: TrackingEventType {
    
    var category: String
    var name: String
    var metadata: [String : Any]
    
    private init(name: String, metadata: [String: Any] = [:]) {
        self.name = name
        self.metadata = metadata
        self.category = "Error"
    }
}
