//
//  CCHDarwinNotificationCenterUtilsTests.swift
//  CCHDarwinNotificationCenter Example
//
//  Created by Hoefele, Claus on 30.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

import UIKit
import XCTest

class CCHDarwinNotificationCenterUtilsTests: XCTestCase {

    func testHostAppExtensionString() {
        let extensionStrings = CCHDarwinNotificationCenterUtils.extensionStringsForEndpoints(.HostApp)
        XCTAssertEqual(extensionStrings.count, 1)
        XCTAssertTrue(extensionStrings.first === CCHDarwinNotificationCenterUtilsHostAppExtensionString)
    }
    
    func testTodayWidgetExtensionString() {
        let extensionStrings = CCHDarwinNotificationCenterUtils.extensionStringsForEndpoints(.TodayWidget)
        XCTAssertEqual(extensionStrings.count, 1)
        XCTAssertTrue(extensionStrings.first === CCHDarwinNotificationCenterUtilsTodayWidgetExtensionString)
    }
    
    func testWatchKitExtensionString() {
        let extensionStrings = CCHDarwinNotificationCenterUtils.extensionStringsForEndpoints(.WatchKitExtension)
        XCTAssertEqual(extensionStrings.count, 1)
        XCTAssertTrue(extensionStrings.first === CCHDarwinNotificationCenterUtilsWatchKitExtensionString)
    }

    func testAllExtensionStrings() {
        let extensionStrings = CCHDarwinNotificationCenterUtils.extensionStringsForEndpoints(.All) as [String]
        XCTAssertEqual(extensionStrings.count, 3)
        XCTAssertTrue(contains(extensionStrings, CCHDarwinNotificationCenterUtilsHostAppExtensionString))
        XCTAssertTrue(contains(extensionStrings, CCHDarwinNotificationCenterUtilsTodayWidgetExtensionString))
        XCTAssertTrue(contains(extensionStrings, CCHDarwinNotificationCenterUtilsWatchKitExtensionString))
    }

    func testDefaultExtensionStrings() {
        let extensionStrings = CCHDarwinNotificationCenterUtils.extensionStringsForEndpoints(.Default) as [String]
        XCTAssertEqual(extensionStrings.count, 2)
        XCTAssertTrue(contains(extensionStrings, CCHDarwinNotificationCenterUtilsTodayWidgetExtensionString))
        XCTAssertTrue(contains(extensionStrings, CCHDarwinNotificationCenterUtilsWatchKitExtensionString))
    }

}
