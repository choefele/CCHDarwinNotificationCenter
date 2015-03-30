//
//  ViewController.swift
//  CCHDarwinNotificationCenter Example
//
//  Created by Hoefele, Claus on 30.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var colorSwatchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        colorSwatchView.backgroundColor = UIColor.blueColor()
        CCHDarwinNotificationCenter.sendNotificationWithIdentifier(NOTIFICATION_BLUE)
    }

    @IBAction func changeColorToOrange() {
        colorSwatchView.backgroundColor = UIColor.orangeColor()
        CCHDarwinNotificationCenter.sendNotificationWithIdentifier(NOTIFICATION_ORANGE)
    }

    @IBAction func changeColorToRed() {
        colorSwatchView.backgroundColor = UIColor.redColor()
        CCHDarwinNotificationCenter.sendNotificationWithIdentifier(NOTIFICATION_RED)
    }
    
    func colorDidChangeToBlue() {
        colorSwatchView.backgroundColor = UIColor.blueColor()
    }
    
    func colorDidChangeToOrange() {
        colorSwatchView.backgroundColor = UIColor.orangeColor()
    }
    
    func colorDidChangeToRed() {
        colorSwatchView.backgroundColor = UIColor.redColor()
    }
    
}

