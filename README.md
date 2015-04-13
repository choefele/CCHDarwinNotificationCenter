# CCHDarwinNotificationCenter
Inter-process signaling with addressable receivers using the Darwin notification center.

[![Build Status](https://travis-ci.org/choefele/CCHDarwinNotificationCenter.png?branch=master)](https://travis-ci.org/choefele/CCHDarwinNotificationCenter)&nbsp;![Version](https://cocoapod-badges.herokuapp.com/v/CCHDarwinNotificationCenter/badge.png)&nbsp;![Platform](https://cocoapod-badges.herokuapp.com/p/CCHDarwinNotificationCenter/badge.png)

See [Releases](https://github.com/choefele/CCHDarwinNotificationCenter/releases) for a high-level overview of recent updates.

The example in this repo contains an iPhone app, a Today widget and a WatchKit extension that exchange signals by using `CCHDarwinNotificationCenter`. To see the updates, start at least two processes such as the WatchKit app and the iPhone app.

Need to talk to a human? [I'm @claushoefele on Twitter](https://twitter.com/claushoefele).

## Installation

Use [CocoaPods](http://cocoapods.org) to integrate `CCHDarwinNotificationCenter` into your project. Minimum deployment targets are 7.0 for iOS and 10.9 for OS X.

```ruby
platform :ios, '7.0'
pod "CCHDarwinNotificationCenter"
```

```ruby
platform :osx, '10.9'
pod "CCHDarwinNotificationCenter"
```

## Sending notifications across process boundaries

The [Darwin notification center](https://developer.apple.com/library/mac/documentation/Darwin/Conceptual/MacOSXNotifcationOv/DarwinNotificationConcepts/DarwinNotificationConcepts.html#//apple_ref/doc/uid/TP40005947-CH5-SW1) is a system mechanism on iOS and OS X to send signals across process boundaries. It's useful to exchange information between two or more running processes such as an iPhone app notifying a WatchKit Extension that new data has arrived.

A Darwin notification is a signal only; it can't transport any data apart from the notification identifier. If you need to share data across processes, you can set up an [app group](https://developer.apple.com/library/prerelease/ios/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/EnablingAppSandbox.html#//apple_ref/doc/uid/TP40011195-CH4-SW19), which allows you to exchange data via APIs such as `NSUserDefaults` and Core Data.

Darwin notifications don’t need an app group or any other setup to work. Because the notification namespace is shared across all applications in the system, Apple recommends a reverse-DNS-style naming, for example "com.example.MyMessage".

`CCHDarwinNotificationCenter` simplifies handling Darwin notifications by:
- Providing a simple API to send Darwin notifications with one line of code
- Converting incoming Darwin notifications into notifications that can be received with the `NSNotificationCenter` API
- Mangling notification identifier strings to receive notifications from specific endpoints. 

## Simple Darwin notification API

To send Darwin notifications use:

```Swift
	CCHDarwinNotificationCenter.postNotificationWithIdentifier("com.example.MyMessage")
```

To receive Darwin notifications, first start converting them into `NSNotification`s:

```Swift
	CCHDarwinNotificationCenter.startForwardingDarwinNotificationsWithIdentifier("com.example.MyMessage")
```

Then receive the converted signals via the `NSNotificationCenter` API:

```Swift
	NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationDidReceive", name:"com.example.MyMessage", object: nil)

	func notificationDidReceive() {
        println("notificationDidReceive")
    }
```

## Addressing endpoints

Darwin notifications have the downside of being received by the process of the sender as well. If you have an iPhone app, a Today widget and a WatchKit extension, sending a notification with the same identifier makes it hard to know where the signal came from.

For this reason, `CCHDarwinNotificationCenter` offers an API that appends a process specific string to the notification identifier. This appendix is then used to filter out messages you don't need. The API is as follows:

```Swift
	CCHDarwinNotificationCenter.startForwardingNotificationsWithIdentifier("com.example.MyMessage", fromEndpoints: .Default)
	CCHDarwinNotificationCenter.stopForwardingNotificationsWithIdentifier("com.example.MyMessage", fromEndpoints: .Default)
	CCHDarwinNotificationCenter.postNotificationWithIdentifier("com.example.MyMessage")
```

Note that this API does not include the word "Darwin" in its methods. The endpoint mask allows you to filter messages where `.Default` means all messages except the ones sent by your own process.
