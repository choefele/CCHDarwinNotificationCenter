//
//  CCHDarwinNotificationCenterUtils.h
//  CCHDarwinNotificationCenter Example
//
//  Created by Hoefele, Claus on 30.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCHDarwinNotificationCenter.h"

extern NSString * const CCHDarwinNotificationCenterUtilsWatchKitExtensionString;
extern NSString * const CCHDarwinNotificationCenterUtilsTodayWidgetExtensionString;
extern NSString * const CCHDarwinNotificationCenterUtilsHostAppExtensionString;

@interface CCHDarwinNotificationCenterUtils : NSObject

#pragma mark - Extension strings

+ (NSArray *)extensionStringsForEndpoints:(DarwinNotificationCenterEndpoint)endpointMask;
+ (NSString *)hashedExtensionString:(NSString *)extensionString;
+ (NSString *)currentExtensionString;

#pragma mark - Identifier mangling

+ (NSString *)mangleIdentifier:(NSString *)identifier extensionString:(NSString *)extensionString;
+ (NSString *)unmangleIdentifier:(NSString *)mangledIdentifier;

@end
