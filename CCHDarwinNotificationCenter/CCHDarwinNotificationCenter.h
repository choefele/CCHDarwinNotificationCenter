//
//  CCHDarwinNotificationCenter.h
//  HereToThere
//
//  Created by Claus Höfele on 06.02.15.
//  Copyright (c) 2015 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, DarwinNotificationCenterEndpoint) {
    DarwinNotificationCenterEndpointHostApp             = (1UL << 0),
    DarwinNotificationCenterEndpointWidget              = (1UL << 1),
    DarwinNotificationCenterEndpointWatchKitExtension   = (1UL << 2),
    DarwinNotificationCenterEndpointAll                 = ~0
};

@interface CCHDarwinNotificationCenter : NSObject

#pragma mark - Darwin notifications that include the address of its sender

+ (void)sendNotificationWithIdentifier:(NSString *)identifier;
+ (void)startForwardingNotificationsWithIdentifier:(NSString *)identifier fromEndpoints:(DarwinNotificationCenterEndpoint)endpointMask;
+ (void)stopForwardingNotificationsWithIdentifier:(NSString *)identifier fromEndpoints:(DarwinNotificationCenterEndpoint)endpointMask;

#pragma mark - Direct access to Darwin notification center API

+ (void)sendDarwinNotificationWithIdentifier:(NSString *)identifier;
+ (void)startForwardingDarwinNotificationsWithIdentifier:(NSString *)identifier;
+ (void)stopForwardingDarwinNotificationsWithIdentifier:(NSString *)identifier;

@end
