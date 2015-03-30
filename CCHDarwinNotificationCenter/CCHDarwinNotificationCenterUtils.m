//
//  CCHDarwinNotificationCenterUtils.m
//  CCHDarwinNotificationCenter Example
//
//  Created by Hoefele, Claus on 30.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "CCHDarwinNotificationCenterUtils.h"

NSString * const CCHDarwinNotificationCenterUtilsWatchKitExtensionString = @"com.apple.watchkit";
NSString * const CCHDarwinNotificationCenterUtilsTodayWidgetExtensionString = @"com.apple.widget-extension";
NSString * const CCHDarwinNotificationCenterUtilsHostAppExtensionString = @"";

@implementation CCHDarwinNotificationCenterUtils

#pragma mark - Extension strings

+ (NSArray *)extensionStringsForEndpoints:(DarwinNotificationCenterEndpoint)endpointMask
{
    NSMutableArray *extensionStrings = [[NSMutableArray alloc] init];
    
    if (endpointMask & DarwinNotificationCenterEndpointHostApp) [extensionStrings addObject:CCHDarwinNotificationCenterUtilsHostAppExtensionString];
    if (endpointMask & DarwinNotificationCenterEndpointTodayWidget) [extensionStrings addObject:CCHDarwinNotificationCenterUtilsTodayWidgetExtensionString];
    if (endpointMask & DarwinNotificationCenterEndpointWatchKitExtension) [extensionStrings addObject:CCHDarwinNotificationCenterUtilsWatchKitExtensionString];
    
    if (endpointMask & DarwinNotificationCenterEndpointExcludeCurrent) {
        [extensionStrings removeObject:[CCHDarwinNotificationCenterUtils currentExtensionString]];
    }
    
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
    return extensionString ? extensionString : CCHDarwinNotificationCenterUtilsHostAppExtensionString;
}

#pragma mark - Identifier mangling

+ (NSString *)mangleIdentifier:(NSString *)identifier extensionString:(NSString *)extensionString
{
    NSParameterAssert(identifier.length > 0);
    NSParameterAssert(extensionString.length > 0);
    
    return [NSString stringWithFormat:@"%@-%@", identifier, extensionString];
}

+ (NSString *)unmangleIdentifier:(NSString *)mangledIdentifier
{
    NSParameterAssert(mangledIdentifier.length > 0);
    
    NSRange extensionStringRange = [mangledIdentifier rangeOfString:@"-" options:NSBackwardsSearch];
    NSAssert(extensionStringRange.location != NSNotFound, @"Invalid mangled identifier");
    return [mangledIdentifier substringToIndex:extensionStringRange.location];
}

@end
