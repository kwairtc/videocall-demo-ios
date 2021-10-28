//
//  KWRtcUser.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/16.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KWRtcUserIdentity) {
    KWRtcUserIdentityNormal,
    KWRtcUserIdentityMyself,
};

@interface KWRtcUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL openCamera;
@property (nonatomic, assign) BOOL openMicphone;
@property (nonatomic, assign) KWRtcUserIdentity identity;

@end

NS_ASSUME_NONNULL_END
