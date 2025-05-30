//
//  TrackingEventType.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/21.
//

import Foundation

public protocol TrackingEventType {
    
    var category: String { get }
    var name: String { get }
    var metadata: [String: Any] { get }
}
