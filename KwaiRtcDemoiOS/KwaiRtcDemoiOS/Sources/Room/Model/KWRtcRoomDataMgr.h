//
//  KWRtcRoomDataMgr.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/16.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWRtcUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KWRtcRoomDataMgrDelegate <NSObject>

@optional
- (void)dataMgrDidUpdateUserInfo:(NSString *)uid;

@end

@interface KWRtcRoomDataMgr : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<KWRtcUser *> *userList;
@property (nonatomic, weak) id<KWRtcRoomDataMgrDelegate> delegate;

- (nullable KWRtcUser *)userWithUid:(NSString *)uid;

- (void)attemptAddNewUserWithUid:(NSString *)uid;
- (void)removeUserWithUid:(NSString *)uid;

- (void)updateMicphoneStatus:(BOOL)micphoneOpen uid:(NSString *)uid;
- (void)updateCameraStatus:(BOOL)cameraOpen uid:(NSString *)uid;
- (void)onUserInfoUpdate:(NSString *)uid;


@end

NS_ASSUME_NONNULL_END
