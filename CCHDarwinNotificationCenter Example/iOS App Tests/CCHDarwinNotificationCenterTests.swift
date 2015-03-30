//
//  CCHDarwinNotificationCenter_ExampleTests.swift
//  CCHDarwinNotificationCenter ExampleTests
//
//  Created by Hoefele, Claus on 30.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

import UIKit
import XCTest

let NOTIFICATION = "CCHDarwinNotificationCenterTests"

class CCHDarwinNotificationCenterTests: XCTestCase {
    
    func testDarwinNotifications() {
        let expectation = expectationForNotification(NOTIFICATION, object: nil, handler: nil)
        
        CCHDarwinNotificationCenter.startForwardingDarwinNotificationsWithIdentifier(NOTIFICATION)
        CCHDarwinNotificationCenter.postDarwinNotificationWithIdentifier(NOTIFICATION)
        waitForExpectationsWithTimeout(1, handler: nil);

        CCHDarwinNotificationCenter.stopForwardingDarwinNotificationsWithIdentifier(NOTIFICATION)
    }
    
    func testMangledNotifications() {
        let expectation = expectationForNotification(NOTIFICATION, object: nil, handler: nil)
        
        CCHDarwinNotificationCenter.startForwardingNotificationsWithIdentifier(NOTIFICATION, fromEndpoints: .All)
        CCHDarwinNotificationCenter.postNotificationWithIdentifier(NOTIFICATION)
        waitForExpectationsWithTimeout(1, handler: nil);
        
        CCHDarwinNotificationCenter.stopForwardingNotificationsWithIdentifier(NOTIFICATION, fromEndpoints: .All)
    }
    
}
