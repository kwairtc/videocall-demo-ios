//
//  KWRtcQosInfo.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/17.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWRtcQosInfo : NSObject

@property (nonatomic, assign) NSUInteger atxBitrateKbps;
@property (nonatomic, assign) NSUInteger arxBitrateKbps;
@property (nonatomic, assign) NSUInteger vtxBitrateKbps;
@property (nonatomic, assign) NSUInteger vrxBitrateKbps;
@property (nonatomic, assign) NSInteger txPktLossRate;
@property (nonatomic, assign) NSInteger rxPktLossRate;
@property (nonatomic, assign) NSUInteger cpuAppUsage;
@property (nonatomic, assign) NSUInteger cpuTotalUsage;
@property (nonatomic, assign) NSUInteger memoryAppUsageKb;
@property (nonatomic, assign) NSInteger rtt;
@property (nonatomic, assign) NSUInteger encodedFrameWidth;
@property (nonatomic, assign) NSUInteger encodedFrameHeight;
@property (nonatomic, assign) NSUInteger captureFrameRate;
@property (nonatomic, assign) NSUInteger targetFrameRate;

- (NSString *)txPktLossRateString;
- (NSString *)rxPktLossRateString;
- (NSString *)rttString;

@end

NS_ASSUME_NONNULL_END
