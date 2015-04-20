//
//  CCHDarwinNotificationCenter.h
//  HereToThere
//
//  Created by Claus Höfele on 06.02.15.
//  Copyright (c) 2015 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#endif

#ifndef NS_ASSUME_NONNULL_END
#define NS_ASSUME_NONNULL_END
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, DarwinNotificationCenterEndpoint) {
    DarwinNotificationCenterEndpointExcludeCurrent    = (1UL << 0),
    DarwinNotificationCenterEndpointHostApp           = (1UL << 1),
    DarwinNotificationCenterEndpointTodayWidget       = (1UL << 2),
    DarwinNotificationCenterEndpointWatchKitExtension = (1UL << 3),
    DarwinNotificationCenterEndpointAll               = DarwinNotificationCenterEndpointHostApp | DarwinNotificationCenterEndpointTodayWidget | DarwinNotificationCenterEndpointWatchKitExtension,
    DarwinNotificationCenterEndpointDefault           = DarwinNotificationCenterEndpointAll | DarwinNotificationCenterEndpointExcludeCurrent,
};

@interface CCHDarwinNotificationCenter : NSObject

#pragma mark - Darwin notifications that include the address of its sender

+ (void)postNotificationWithIdentifier:(NSString *)identifier;
+ (void)startForwardingNotificationsWithIdentifier:(NSString *)identifier fromEndpoints:(DarwinNotificationCenterEndpoint)endpointMask;
+ (void)stopForwardingNotificationsWithIdentifier:(NSString *)identifier fromEndpoints:(DarwinNotificationCenterEndpoint)endpointMask;

#pragma mark - Direct access to Darwin notification center API

+ (void)postDarwinNotificationWithIdentifier:(NSString *)identifier;
+ (void)startForwardingDarwinNotificationsWithIdentifier:(NSString *)identifier;
+ (void)stopForwardingDarwinNotificationsWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END