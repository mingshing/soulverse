//
//  SummitTrackerTests.swift
//  KonoSummitTests
//
//  Created by mingshing on 2022/1/4.
//

import XCTest
@testable import Soulverse

class SummitTrackerTests: XCTestCase {

    var sut: SummitTracker?

    func test_SummitTracker_have_correct_trackingService_after_init() {
        
        sut = SummitTracker()
        XCTAssertNotNil(sut?.services)
        XCTAssertEqual(sut?.count(ofType: FirebaseTrackingService.self), 1)
        
    }
    
    func test_SummitTracker_set_trackingService_userProperty_after_init() {
        let mockUser = UserMock()
        let mockTrackService = TrackingServiceMock()
        sut = SummitTracker(mockUser, services: [mockTrackService])
        
        XCTAssertNotNil(sut?.services)
        XCTAssertEqual(sut?.count(ofType: TrackingServiceMock.self), 1)
        XCTAssertEqual(mockUser.userId, mockTrackService.trackedUserId)
        XCTAssertEqual(mockUser.email, mockTrackService.trackedUserEmail)
    }
    
    func test_SummitTracker_send_trackingEvent_success() {
        let mockUser = UserMock()
        let mockTrackService = TrackingServiceMock()
        let testEventName = "Test Event"
        let testEventProperties: [String: Any] = ["stringKey": "string", "intKey": 1]
        let mockEvent = TrackingEventMock(testEventName, eventProperties: testEventProperties)
        sut = SummitTracker(mockUser, services: [mockTrackService])
        
        sut?.track(mockEvent)
        
        XCTAssertNotNil(mockTrackService.trackedEvent)
        XCTAssertEqual(mockTrackService.trackedEvent?.name, testEventName)
        XCTAssertEqual(mockTrackService.trackedEvent?.metadata["stringKey"] as! String, "string")
        XCTAssertEqual(mockTrackService.trackedEvent?.metadata["intKey"] as! Int, 1)
    }
}

private extension SummitTracker {
    func count<T>(ofType: T.Type) -> Int {
        return services.filter{ $0 is T}.count
    }
}
