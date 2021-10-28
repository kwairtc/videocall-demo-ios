//
//  KWRtcQosInfo.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/17.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWRtcQosInfo.h"

@implementation KWRtcQosInfo

- (NSString *)txPktLossRateString {
    if (self.txPktLossRate < 0) {
        return @"-";
    }
    return [NSString stringWithFormat:@"%ld%%", (long)(self.txPktLossRate / 10)];
}

- (NSString *)rxPktLossRateString {
    if (self.rxPktLossRate < 0) {
        return @"-";
    }
    return [NSString stringWithFormat:@"%ld%%", (long)(self.rxPktLossRate / 10)];
}

- (NSString *)rttString {
    if (self.rtt < 0) {
        return @"-";
    }
    return [NSString stringWithFormat:@"%ldms", (long)self.rtt];
}

@end
