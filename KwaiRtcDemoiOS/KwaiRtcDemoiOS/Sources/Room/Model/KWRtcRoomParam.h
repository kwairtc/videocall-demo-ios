//
//  KWRtcRoomParam.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/12.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWRtcRoomParam : NSObject

@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL micphoneOpen;
@property (nonatomic, assign) BOOL cameraOpen;

@end

NS_ASSUME_NONNULL_END
