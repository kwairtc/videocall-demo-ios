//
//  KWRtcRoomDataMgr.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/16.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWRtcRoomDataMgr.h"

@interface KWRtcRoomDataMgr ()

@property (nonatomic, strong) NSMutableArray<KWRtcUser *> *userList;

@end

@implementation KWRtcRoomDataMgr

- (instancetype)init {
    if (self = [super init]) {
        self.userList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (nullable KWRtcUser *)userWithUid:(NSString *)uid {
    for (KWRtcUser *user in self.userList) {
        if ([user.userId isEqualToString:uid]) {
            return user;
        }
    }
    return nil;
}

- (void)attemptAddNewUserWithUid:(NSString *)uid {
    if (![self userWithUid:uid]) {
        KWRtcUser *user = [[KWRtcUser alloc] init];
        user.userId = uid;
        user.openCamera = NO;
        user.openMicphone = NO;
        [self.userList addObject:user];
        [self onUserInfoUpdate:uid];
    }
}

- (void)removeUserWithUid:(NSString *)uid {
    KWRtcUser *user = [self userWithUid:uid];
    if (user) {
        [self.userList removeObject:user];
        [self onUserInfoUpdate:uid];
    }
}

- (void)updateMicphoneStatus:(BOOL)micphoneOpen uid:(NSString *)uid {
    KWRtcUser *user = [self userWithUid:uid];
    if (user) {
        user.openMicphone = micphoneOpen;
        [self onUserInfoUpdate:uid];
    }
}

- (void)updateCameraStatus:(BOOL)cameraOpen uid:(NSString *)uid {
    KWRtcUser *user = [self userWithUid:uid];
    if (user) {
        user.openCamera = cameraOpen;
        [self onUserInfoUpdate:uid];
    }
}

- (void)onUserInfoUpdate:(NSString *)uid {
    if ([self.delegate respondsToSelector:@selector(dataMgrDidUpdateUserInfo:)]) {
        [self.delegate dataMgrDidUpdateUserInfo:uid];
    }
}

@end
