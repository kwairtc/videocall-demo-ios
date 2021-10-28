//
//  KWRtcSharedDataMgr.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/17.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWRtcSharedDataMgr.h"

@implementation KWRtcResolutionItem

- (NSUInteger)width {
    if (self.resolution == 360) {
        return 360;
    } else if (self.resolution == 540) {
        return 540;
    } else if (self.resolution == 720) {
        return 720;
    }
    return 0;
}

- (NSUInteger)height {
    if (self.resolution == 360) {
        return 640;
    } else if (self.resolution == 540) {
        return 960;
    } else if (self.resolution == 720) {
        return 1280;
    }
    return 0;
}

- (NSUInteger)bitrate {
    if (self.resolution == 360) {
        return 800;
    } else if (self.resolution == 540) {
        return 1000;
    } else if (self.resolution == 720) {
        return 1500;
    }
    return 0;
}

- (NSUInteger)minBitrate {
    if (self.resolution == 360) {
        return 150;
    } else if (self.resolution == 540) {
        return 200;
    } else if (self.resolution == 720) {
        return 300;
    }
    return 0;
}

- (NSUInteger)maxBitrate {
    if (self.resolution == 360) {
        return 800;
    } else if (self.resolution == 540) {
        return 1200;
    } else if (self.resolution == 720) {
        return 1800;
    }
    return 0;
}

- (NSUInteger)frameRate {
    if (self.resolution == 360) {
        return 15;
    } else if (self.resolution == 540) {
        return 15;
    } else if (self.resolution == 720) {
        return 15;
    }
    return 0;
}

@end

@implementation KWRtcSharedDataMgr

static KWRtcSharedDataMgr *sharedInstance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KWRtcSharedDataMgr alloc] init];
        sharedInstance.currentResolution = @(360);
        sharedInstance.enableConsole = NO;
    });
    return sharedInstance;
}

+ (NSDictionary *)resolutionMap {
    static KWRtcResolutionItem *item360;
    static KWRtcResolutionItem *item540;
    static KWRtcResolutionItem *item720;
    if (!item360) {
        item360 = [[KWRtcResolutionItem alloc] init];
        item360.resolution = 360;
    }
    if (!item540) {
        item540 = [[KWRtcResolutionItem alloc] init];
        item540.resolution = 540;
    }
    if (!item720) {
        item720 = [[KWRtcResolutionItem alloc] init];
        item720.resolution = 720;
    }
    return @{@(360): item360,
             @(540): item540,
             @(720): item720};
}

+ (NSUInteger)sampleRate {
    return 48000;
}

@end
