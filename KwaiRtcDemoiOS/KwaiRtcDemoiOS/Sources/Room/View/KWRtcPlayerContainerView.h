//
//  KWRtcPlayerContainerView.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/12.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWRtcPlayerWrapperView.h"
#import "KWRtcRoomDataMgr.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KWRtcPlayerContainerViewDelegate <NSObject>

@optional
- (void)playerContainerDidReloadLayout:(BOOL)multiScreen;
- (void)playerContainerDidEndScroll:(BOOL)decelerate;

@end

@interface KWRtcPlayerContainerView : UIView

@property (nonatomic, weak) id<KWRtcPlayerContainerViewDelegate> delegate;
@property (nonatomic, strong, readonly) KWRtcPlayerWrapperView *localVideoWrapperView;
@property (nonatomic, strong, readonly) NSMutableArray<KWRtcPlayerWrapperView *> *remoteVideoWrapperArray;
@property (nonatomic, weak) KWRtcRoomDataMgr *dataMgr;
@property (nonatomic, weak) UIPageControl *pageCtrl;

- (void)reloadVideoLayout;

- (void)appendLocalViewWithUid:(NSString *)uid completion:(void(^)(UIView *view))completion;
- (void)appendRemoteViewWithUid:(NSString *)uid completion:(void(^)(UIView *view))completion;
- (void)removeRemoteViewWithUid:(NSString *)uid completion:(void(^)(void))completion;
- (void)remoteMuteAudio:(BOOL)mute uid:(NSString *)uid;
- (void)remoteMuteVideo:(BOOL)mute uid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
