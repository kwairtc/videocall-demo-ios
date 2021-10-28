//
//  KWRtcSharedDataMgr.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/17.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWRtcResolutionItem : NSObject

@property (nonatomic, assign) NSUInteger resolution;

- (NSUInteger)width;
- (NSUInteger)height;
- (NSUInteger)bitrate;
- (NSUInteger)minBitrate;
- (NSUInteger)maxBitrate;
- (NSUInteger)frameRate;

@end

@interface KWRtcSharedDataMgr : NSObject

@property (nonatomic, strong) NSNumber *currentResolution;
@property (nonatomic, assign) BOOL enableConsole;

+ (instancetype)sharedInstance;
+ (NSDictionary *)resolutionMap;
+ (NSUInteger)sampleRate;

@end

NS_ASSUME_NONNULL_END
