//
//  CCHDarwinNotificationCenter.m
//  HereToThere
//
//  Created by Claus Höfele on 06.02.15.
//  Copyright (c) 2015 Option-U Software. All rights reserved.
//

#import "CCHDarwinNotificationCenter.h"

static NSString * const EXTENSION_STRING_WATCH_KIT_EXTENSION = @"com.apple.watchkit";
static NSString * const EXTENSION_STRING_WIDGET = @"com.apple.widget-extension";
static NSString * const EXTENSION_STRING_HOST_APP = @"";

@implementation CCHDarwinNotificationCenter

#pragma mark - Darwin notifications that include the address of its sender

+ (void)sendNotificationWithIdentifier:(NSString *)identifier
{
    NSString *hashedExtensionString = [self.class hashedExtensionString:[self.class currentExtensionString]];
    NSString *mangledIdentifier = mangleIdentifier(identifier, hashedExtensionString);
    [self.class sendDarwinNotificationWithIdentifier:mangledIdentifier];
}

+ (void)startForwardingNotificationsWithIdentifier:(NSString *)identifier fromEndpoints:(DarwinNotificationCenterEndpoint)endpointMask
{
    NSArray *extensionStrings = [self.class extensionStringsForEndpoints:endpointMask];
    for (NSString *extensionString in extensionStrings) {
        NSString *hashedExtensionString = [self.class hashedExtensionString:extensionString];
        NSString *mangledIdentifier = mangleIdentifier(identifier, hashedExtensionString);
        
        CFStringRef identifierAsStringRef = (__bridge CFStringRef)mangledIdentifier;
        CFNotificationCenterRef const darwinNotificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
        CFNotificationCenterAddObserver(darwinNotificationCenter, NULL, mangledNotificationCallback, identifierAsStringRef, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
}

+ (void)stopForwardingNotificationsWithIdentifier:(NSString *)identifier fromEndpoints:(DarwinNotificationCenterEndpoint)endpointMask
{
    NSArray *extensionStrings = [self.class extensionStringsForEndpoints:endpointMask];
    for (NSString *extensionString in extensionStrings) {
        NSString *hashedExtensionString = [self.class hashedExtensionString:extensionString];
        NSString *mangledIdentifier = mangleIdentifier(identifier, hashedExtensionString);
        [self.class stopForwardingDarwinNotificationsWithIdentifier:mangledIdentifier];
    }
}

static void mangledNotificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef identifierAsStringRef, void const *object, CFDictionaryRef userInfo) {
    NSString *mangledIdentifier = (__bridge NSString *)identifierAsStringRef;
    NSString *identifier = unmangleIdentifier(mangledIdentifier);
    notificationCallback(center, observer, (__bridge CFStringRef)identifier, object, userInfo);
}

#pragma mark - Direct access to Darwin notification center

+ (void)sendDarwinNotificationWithIdentifier:(NSString *)identifier
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

#pragma mark - Extension strings

+ (NSArray *)extensionStringsForEndpoints:(DarwinNotificationCenterEndpoint)endpointMask
{
    NSMutableArray *extensionStrings = [[NSMutableArray alloc] init];
    
    if (endpointMask & DarwinNotificationCenterEndpointHostApp) [extensionStrings addObject:EXTENSION_STRING_HOST_APP];
    if (endpointMask & DarwinNotificationCenterEndpointWidget) [extensionStrings addObject:EXTENSION_STRING_WIDGET];
    if (endpointMask & DarwinNotificationCenterEndpointWatchKitExtension) [extensionStrings addObject:EXTENSION_STRING_WATCH_KIT_EXTENSION];
//    [extensionStrings removeObject:[self.class currentExtensionString]];
    
    return extensionStrings;
}

+ (NSString *)hashedExtensionString:(NSString *)extensionString
{
    NSUInteger hashedExtensionString;
    
    if (extensionString.length > 0) {
        hashedExtensionString = extensionString.hash;
    } else {
        hashedExtensionString = 0;
    }
    
    return [NSString stringWithFormat:@"%tu", hashedExtensionString];
}

+ (NSString *)currentExtensionString
{
    NSDictionary *extensionInfo = [NSBundle.mainBundle objectForInfoDictionaryKey:@"NSExtension"];
    NSString *extensionString = extensionInfo[@"NSExtensionPointIdentifier"];
    return extensionString ? extensionString : EXTENSION_STRING_HOST_APP;
}

#pragma mark - Identifier mangling

static NSString *mangleIdentifier(NSString *identifier, NSString *extensionString) {
    assert(identifier.length > 0);
    
    return [NSString stringWithFormat:@"%@-%@", identifier, extensionString];
}

static NSString *unmangleIdentifier(NSString *mangledIdentifier) {
    assert(mangledIdentifier.length > 0);
    
    NSRange extensionStringRange = [mangledIdentifier rangeOfString:@"-" options:NSBackwardsSearch];
    assert(extensionStringRange.location != NSNotFound && @"Invalid mangled string");
    return [mangledIdentifier substringToIndex:extensionStringRange.location];
}

@end
