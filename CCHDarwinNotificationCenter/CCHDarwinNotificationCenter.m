//
//  CCHDarwinNotificationCenter.m
//  HereToThere
//
//  Created by Claus Höfele on 06.02.15.
//  Copyright (c) 2015 Option-U Software. All rights reserved.
//

#import "CCHDarwinNotificationCenter.h"

#import "CCHDarwinNotificationCenterUtils.h"

@implementation CCHDarwinNotificationCenter

#pragma mark - Darwin notifications that include the address of its sender

+ (void)postNotificationWithIdentifier:(NSString *)identifier
{
    NSString *hashedExtensionString = [CCHDarwinNotificationCenterUtils hashedExtensionString:[CCHDarwinNotificationCenterUtils currentExtensionString]];
    NSString *mangledIdentifier = [CCHDarwinNotificationCenterUtils mangleIdentifier:identifier extensionString:hashedExtensionString];
    [self.class postDarwinNotificationWithIdentifier:mangledIdentifier];
}

+ (void)startForwardingNotificationsWithIdentifier:(NSString *)identifier fromEndpoints:(DarwinNotificationCenterEndpoint)endpointMask
{
    NSArray *extensionStrings = [CCHDarwinNotificationCenterUtils extensionStringsForEndpoints:endpointMask];
    for (NSString *extensionString in extensionStrings) {
        NSString *hashedExtensionString = [CCHDarwinNotificationCenterUtils hashedExtensionString:extensionString];
        NSString *mangledIdentifier = [CCHDarwinNotificationCenterUtils mangleIdentifier:identifier extensionString:hashedExtensionString];
        
        CFStringRef identifierAsStringRef = (__bridge CFStringRef)mangledIdentifier;
        CFNotificationCenterRef const darwinNotificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
        CFNotificationCenterAddObserver(darwinNotificationCenter, NULL, mangledNotificationCallback, identifierAsStringRef, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
}

+ (void)stopForwardingNotificationsWithIdentifier:(NSString *)identifier fromEndpoints:(DarwinNotificationCenterEndpoint)endpointMask
{
    NSArray *extensionStrings = [CCHDarwinNotificationCenterUtils extensionStringsForEndpoints:endpointMask];
    for (NSString *extensionString in extensionStrings) {
        NSString *hashedExtensionString = [CCHDarwinNotificationCenterUtils hashedExtensionString:extensionString];
        NSString *mangledIdentifier = [CCHDarwinNotificationCenterUtils mangleIdentifier:identifier extensionString:hashedExtensionString];
        [self.class stopForwardingDarwinNotificationsWithIdentifier:mangledIdentifier];
    }
}

static void mangledNotificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef identifierAsStringRef, void const *object, CFDictionaryRef userInfo) {
    NSString *mangledIdentifier = (__bridge NSString *)identifierAsStringRef;
    NSString *identifier = [CCHDarwinNotificationCenterUtils unmangleIdentifier:mangledIdentifier];
    notificationCallback(center, observer, (__bridge CFStringRef)identifier, object, userInfo);
}

#pragma mark - Direct access to Darwin notification center

+ (void)postDarwinNotificationWithIdentifier:(NSString *)identifier
{
    CFStringRef identifierAsStringRef = (__bridge CFStringRef)identifier;
    CFNotificationCenterRef const darwinNotificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(darwinNotificationCenter, identifierAsStringRef, NULL, NULL, YES);
}

+ (void)startForwardingDarwinNotificationsWithIdentifier:(NSString *)identifier
{
    CFStringRef identifierAsStringRef = (__bridge CFStringRef)identifier;
    CFNotificationCenterRef const darwinNotificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(darwinNotificationCenter, NULL, notificationCallback, identifierAsStringRef, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

+ (void)stopForwardingDarwinNotificationsWithIdentifier:(NSString *)identifier
{
    CFStringRef identifierAsStringRef = (__bridge CFStringRef)identifier;
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterRemoveObserver(center, NULL, identifierAsStringRef, NULL);
}

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef identifierAsStringRef, void const *object, CFDictionaryRef userInfo) {
    NSString *identifier = (__bridge NSString *)identifierAsStringRef;
    [NSNotificationCenter.defaultCenter postNotificationName:identifier object:nil userInfo:nil];
}

@end
