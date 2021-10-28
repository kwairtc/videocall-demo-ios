//
//  NSDictionary+KWExt.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/24.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "NSDictionary+KWExt.h"

@implementation NSDictionary (KWExt)

- (NSString *)jsonString {
    if (@available(iOS 11.0, *)) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingSortedKeys error:nil];
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    } else {
        NSData *json = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
}

@end
