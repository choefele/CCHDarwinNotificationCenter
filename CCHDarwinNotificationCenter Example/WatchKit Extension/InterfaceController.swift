//
//  InterfaceController.swift
//  CCHDarwinNotificationCenter Example WatchKit Extension
//
//  Created by Hoefele, Claus on 30.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet private weak var colorSwatchGroup: WKInterfaceGroup!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // This turns Darwin notifications into standard NSNotifications
        CCHDarwinNotificationCenter.startForwardingNotificationsWithIdentifier(NOTIFICATION_BLUE, fromEndpoints: .All)
        CCHDarwinNotificationCenter.startForwardingNotificationsWithIdentifier(NOTIFICATION_ORANGE, fromEndpoints: .All)
        CCHDarwinNotificationCenter.startForwardingNotificationsWithIdentifier(NOTIFICATION_RED, fromEndpoints: .All)
        
        // Observe standard NSNotifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "colorDidChangeToBlue", name:NOTIFICATION_BLUE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "colorDidChangeToOrange", name:NOTIFICATION_ORANGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "colorDidChangeToRed", name:NOTIFICATION_RED, object: nil)
    }

    @IBAction func changeColorToBlue() {
        colorSwatchGroup.setBackgroundColor(UIColor.blueColor())
        CCHDarwinNotificationCenter.sendNotificationWithIdentifier(NOTIFICATION_BLUE)
    }

    @IBAction func changeColorToOrange() {
        colorSwatchGroup.setBackgroundColor(UIColor.orangeColor())
        CCHDarwinNotificationCenter.sendNotificationWithIdentifier(NOTIFICATION_ORANGE)
    }

    @IBAction func changeColorToRed() {
        colorSwatchGroup.setBackgroundColor(UIColor.redColor())
        CCHDarwinNotificationCenter.sendNotificationWithIdentifier(NOTIFICATION_RED)
    }
    
    func colorDidChangeToBlue() {
        colorSwatchGroup.setBackgroundColor(UIColor.blueColor())
    }
    
    func colorDidChangeToOrange() {
        colorSwatchGroup.setBackgroundColor(UIColor.orangeColor())
    }
    
    func colorDidChangeToRed() {
        colorSwatchGroup.setBackgroundColor(UIColor.redColor())
    }

}
