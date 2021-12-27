//
//  KWRtcRoomViewController.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/12.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWRtcRoomViewController.h"
#import "KWRtcDemoUI.h"
#import "KWRtcPlayerContainerView.h"
#import "KWSettingViewController.h"
#import "KWRtcRoomDataMgr.h"
#import <AVKit/AVKit.h>
#import "KWRtcSharedDataMgr.h"
#import "KWRtcQosInfo.h"
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
#import <KRtcEngine/KuaishouRtcEngine.h>
#endif

@interface KWRtcRoomViewController () <KuaishouRtcEngineDelegate, KWRtcRoomNavigationBarViewDelegate, KWRtcRoomToolbarViewDelegate, KWRtcRoomDataMgrDelegate, KWRtcRoomBeautyViewDelegate, KWRtcRoomInfoViewDelegate, KWRtcPlayerContainerViewDelegate>

@property (nonatomic, strong) KWRtcPlayerContainerView *playerContainerView;
@property (nonatomic, strong) KWRtcRoomNavigationBarView *naviBarView;
@property (nonatomic, strong) KWRtcRoomToolbarView *toolbarView;
@property (nonatomic, strong) KWRtcRoomConsoleView *consoleView;
@property (nonatomic, strong) KWRtcRoomMemberView *memberView;
@property (nonatomic, strong) KWRtcRoomBeautyView *beautyView;
@property (nonatomic, strong) KWRtcRoomInfoView *infoView;
@property (nonatomic, strong) KWPageControl *pageCtrl;
@property (nonatomic, strong) KWRtcRoomDataMgr *dataMgr;
@property (nonatomic, strong) KWRtcQosInfo *qosInfo;
@property (nonatomic, assign) BOOL videoMultiScreenMode;
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
@property (nonatomic, strong) KuaishouRtcEngine *rtcEngine;
@property (nonatomic, strong) KuaishouRtcEngineBeautyOptions *beautyOptions;
@property (nonatomic, strong) NSMutableDictionary *canvasDict;
#endif

@end

@implementation KWRtcRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWColorFromHex(0xE3E3E3);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.videoMultiScreenMode = NO;
    [self buildUI];
    [self buildRtcEngine];
    [self updateUI];
    [self bindObservers];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)buildUI {
    [self.view addSubview:self.playerContainerView];
    [self.view addSubview:self.naviBarView];
    [self.view addSubview:self.toolbarView];
    [self.view addSubview:self.pageCtrl];
    [self.view addSubview:self.consoleView];
    [self.view addSubview:self.memberView];
    [self.view addSubview:self.beautyView];
    [self.view addSubview:self.infoView];

    [self.naviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo([KWRtcRoomNavigationBarView defaultHeight]);
    }];

    [self.playerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBarView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.toolbarView.mas_top);
    }];

    [self.toolbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo([KWRtcRoomToolbarView defaultHeight]);
    }];

    [self.consoleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.toolbarView.mas_top);
        make.width.mas_equalTo([KWRtcRoomConsoleView defaultWidth]);
        make.height.mas_equalTo([KWRtcRoomConsoleView defaultHeight]);
    }];

    [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.beautyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.pageCtrl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.toolbarView);
        make.top.equalTo(self.toolbarView).offset(-6);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(28);
    }];
}

- (void)buildRtcEngine {
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    // 初始化KuaishouRtcEngine对象
    KuaishouRtcEngineConfig *config = [[KuaishouRtcEngineConfig alloc] init];
    config.appId = KRTC_APP_ID;
    config.appName = KRTC_APP_NAME;
    config.appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    config.appUserId = self.roomParam.userId;
    config.deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    self.rtcEngine = [[KuaishouRtcEngine alloc] initEngineWithConfig:config delegate:self];

    // 设置KuaishouRtcEngine日志参数
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logPath = [NSString stringWithFormat:@"%@/%@", docPaths[0], RTC_DEMO_LOG_PATH];
    [[NSFileManager defaultManager] createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:nil error:nil];
    [KuaishouRtcEngine setLogLevel:KuaishouRtcEngineLogLevelInfo];
    [KuaishouRtcEngine setLogFile:[NSString stringWithFormat:@"%@/%@", logPath, RTC_DEMO_LOG_FILE]];
    [KuaishouRtcEngine setLogFileSize:10 * 1024];
    [KuaishouRtcEngine setLogFileNum:5];

    // 设置编码配置
    // 如果你的App支持会中切换清晰度，请在初始化视频前指定最高档位，初始化视频后再指定为你希望的默认档位
    [self reloadEncoderConfiguration:@(720)];

    // 根据业务需要设置是否订阅大小流，这里演示只订阅小流
    [self.rtcEngine setRemoteDefaultVideoStreamType:self.roomParam.channelId streamType:KuaishouRtcRemoteVideoStreamTypeLow];

    // 启用视频模块
    [self.rtcEngine enableVideo];

    // 初始化本地摄像头/麦克风状态
    if (self.roomParam.cameraOpen) {
        [self.rtcEngine unmuteLocalVideoStream:self.roomParam.channelId];
        [self.rtcEngine startPreview];
    } else {
        [self.rtcEngine muteLocalVideoStream:self.roomParam.channelId];
    }
    if (self.roomParam.micphoneOpen) {
        [self.rtcEngine unmuteLocalAudioStream];
        [self.rtcEngine enableLocalAudio];
    } else {
        [self.rtcEngine muteLocalAudioStream];
        [self.rtcEngine disableLocalAudio];
    }

    // 切换编码配置
    [self reloadEncoderConfiguration:[KWRtcSharedDataMgr sharedInstance].currentResolution];

    KWWS;
    [self.playerContainerView appendLocalViewWithUid:self.roomParam.userId completion:^(UIView *view) {
        // 这里生成view的逻辑根据你自己的需要来实现，生成好的view传给SDK即可
        KWSS;
        // 绑定本地视图
        KuaishouRtcEngineVideoCanvas *canvas = [[KuaishouRtcEngineVideoCanvas alloc] initWithUIView:view channelId:self.roomParam.channelId uid:self.roomParam.userId renderMode:KuaishouRtcEngineVideoRenderModeFitWithCropping mirrorMode:KuaishouRtcEngineVideoMirrorModeAuto];
        [self.rtcEngine bindLocalVideoView:canvas];

        // 加入频道
        KuaishouRtcEngineJoinChannelParam *param = [[KuaishouRtcEngineJoinChannelParam alloc] init];
        param.channelProfile = KuaishouRtcEngineChannelProfileRTC;
        param.channelId = self.roomParam.channelId;
        param.userId = self.roomParam.userId;
        param.token = KRTC_APP_SIGN;
        [self.rtcEngine joinChannelByParam:param];

        // 以下为Demo业务层逻辑，可以忽略
        [self.dataMgr attemptAddNewUserWithUid:self.roomParam.userId];
        [self.dataMgr userWithUid:self.roomParam.userId].identity = KWRtcUserIdentityMyself;
        [self.dataMgr userWithUid:self.roomParam.userId].openMicphone = self.roomParam.micphoneOpen;
        [self.dataMgr userWithUid:self.roomParam.userId].openCamera = self.roomParam.cameraOpen;
        [self.dataMgr onUserInfoUpdate:self.roomParam.userId];
        [self.playerContainerView.localVideoWrapperView updateCanvasAvailable:self.roomParam.cameraOpen];
    }];
#endif
}

- (void)updateUI {
    [self.naviBarView updateChannelId:self.roomParam.channelId];
    [self.naviBarView startTimer];
    [self.toolbarView updateMicphoneOpenStatus:self.roomParam.micphoneOpen];
    [self.toolbarView updateCameraOpenStatus:self.roomParam.cameraOpen];
    [self.dataMgr updateMicphoneStatus:self.roomParam.micphoneOpen uid:self.roomParam.userId];
    [self.dataMgr updateCameraStatus:self.roomParam.cameraOpen uid:self.roomParam.userId];
    [self.playerContainerView.localVideoWrapperView updateCanvasAvailable:self.roomParam.cameraOpen];
    [self.playerContainerView.localVideoWrapperView updateMicAvailable:self.roomParam.micphoneOpen];
    [self.toolbarView refreshUI];
    [self.beautyView loadDefaultValue];
    [self.infoView updateChannelId:self.roomParam.channelId];
    self.consoleView.hidden = ![KWRtcSharedDataMgr sharedInstance].enableConsole;
    self.memberView.hidden = YES;
    self.beautyView.hidden = YES;
    self.infoView.hidden = YES;
}

- (void)bindObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onConsoleOpenStatusChanged:) name:KWSettingConsoleStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResolutionChanged:) name:KWSettingResolutionChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Private
- (void)reloadEncoderConfiguration:(NSNumber *)number {
    if (!number) {
        return;
    }
    KWRtcResolutionItem *item = [KWRtcSharedDataMgr resolutionMap][number];
    if (!item) {
        return;
    }
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    KuaishouRtcEngineVideoEncoderConfiguration *cfg = [KuaishouRtcEngineVideoEncoderConfiguration defaultRtcVideoEncoderConfig];
    cfg.dimensions = CGSizeMake(item.width, item.height);
    cfg.minBitrate = item.minBitrate;
    cfg.maxBitrate = item.maxBitrate;
    cfg.bitrate = item.bitrate;
    cfg.frameRate = item.frameRate;
    cfg.orientationMode = KuaishouRtcEngineVideoOutputOrientationModeFixedPortrait;
    NSLog(@"[RoomVc] reload encoder config = %ldP, bitrate = %ldkbps", (long)[number integerValue], (long)cfg.bitrate);
    [self.rtcEngine setVideoEncoderConfiguration:self.roomParam.channelId videoEncoderConfig:cfg];
#endif
}

- (void)reloadVisibleVideoWrapper {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray<KWRtcPlayerWrapperView *> *remoteVideos = [self.playerContainerView remoteVideoWrapperArray];
        for (int i = 0; i < remoteVideos.count; i++) {
            KWRtcPlayerWrapperView *view = remoteVideos[i];
            if (!view.uid.length) {
                continue;
            }
            if (self.videoMultiScreenMode) {
                // 多屏模式，mute不可见的
                BOOL isVisible = [view isVisibleInScreen];
                if (isVisible) {
                    NSLog(@"[RtcEngine] reload unmute remote video cuz invisible: %@", view.uid);
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
                    [self.rtcEngine unmuteRemoteVideoStream:self.roomParam.channelId uid:view.uid];
#endif
                } else {
                    NSLog(@"[RtcEngine] reload mute remote video: %@", view.uid);
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
                    [self.rtcEngine muteRemoteVideoStream:self.roomParam.channelId uid:view.uid];
#endif
                }
            } else {
                // 单屏模式，unmute all
                NSLog(@"[RtcEngine] reload unmute remote video: %@", view.uid);
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
                [self.rtcEngine unmuteRemoteVideoStream:self.roomParam.channelId uid:view.uid];
#endif
            }
        }
    });
}


#pragma mark - Observers
- (void)onConsoleOpenStatusChanged:(NSNotification *)noti {
    BOOL isOpen = [noti.object boolValue];
    NSLog(@"[RoomVc] on console open = %ld", (long)isOpen);
    self.consoleView.hidden = !isOpen;
}

- (void)onResolutionChanged:(NSNotification *)noti {
    NSNumber *number = [KWRtcSharedDataMgr sharedInstance].currentResolution;
    [self reloadEncoderConfiguration:number];
}

- (void)onApplicationEnterBackground:(NSNotification *)noti {
    NSLog(@"[RoomVc] on app enter background");
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    if (self.roomParam.cameraOpen) {
        // if camera open, pause while background
        NSLog(@"[RoomVc] mute local video cuz app background and camera open");
        [self.rtcEngine muteLocalVideoStream:self.roomParam.channelId];
        [self.rtcEngine stopPreview];
        [self.playerContainerView.localVideoWrapperView updateCanvasAvailable:NO];
    }
#endif
}

- (void)onApplicationEnterForegroundNotification:(NSNotification *)noti {
    NSLog(@"[RoomVc] on app enter foreground");
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    if (self.roomParam.cameraOpen) {
        // if camera open, resume while foreground
        NSLog(@"[RoomVc] unmute local video cuz app foreground and camera open");
        [self.rtcEngine unmuteLocalVideoStream:self.roomParam.channelId];
        [self.rtcEngine startPreview];
        [self.playerContainerView.localVideoWrapperView updateCanvasAvailable:YES];
    }
#endif
}

// SDK的回调通知
#pragma mark - KuaishouRtcEngineDelegate
- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine channelId:(NSString *)channelId didOccurWarning:(KuaishouRtcWarningCode)warningCode {
    NSLog(@"[KuaishouRtcEngine] did warning: %ld, chid = %@", (long)warningCode, channelId);
}

- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine channelId:(NSString *)channelId didOccurError:(KuaishouRtcErrorCode)errorCode {
    NSLog(@"[KuaishouRtcEngine] did error: %ld, chid = %@", (long)errorCode, channelId);
}

- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine didJoinChannel:(NSString *)channelId withUid:(NSString *)uid elapsed:(NSInteger)elapsed {
    NSLog(@"[KuaishouRtcEngine] did local joined channel = %@", channelId);
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Dobule-check
        if (self.roomParam.cameraOpen) {
            NSLog(@"[RoomVc] unmute local video after local joined");
            [self.rtcEngine unmuteLocalVideoStream:self.roomParam.channelId];
        } else {
            NSLog(@"[RoomVc] mute local video after local joined");
            [self.rtcEngine muteLocalVideoStream:self.roomParam.channelId];
        }
    });
#endif
}

- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine didLeaveChannelWithStats:(KuaishouRtcEngineChannelStats *)stats {
    NSLog(@"[KuaishouRtcEngine] did local leave channel");
}

- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine didJoinedOfUid:(NSString *)uid channelId:(NSString *)channelId elapsed:(NSInteger)elapsed {
    NSLog(@"[KuaishouRtcEngine] did remote joined uid = %@, channel = %@", uid, channelId);
    [self.dataMgr attemptAddNewUserWithUid:uid];
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    KWWS;
    [self.playerContainerView appendRemoteViewWithUid:uid completion:^(UIView *view) {
        // 这里生成view的逻辑根据你自己的需要来实现，生成好的view传给SDK即可
        KWSS;
        // 绑定远端视图
        KuaishouRtcEngineVideoCanvas *canvas = [[KuaishouRtcEngineVideoCanvas alloc] initWithUIView:view channelId:self.roomParam.channelId uid:uid renderMode:KuaishouRtcEngineVideoRenderModeFitWithCropping mirrorMode:KuaishouRtcEngineVideoMirrorModeAuto];
        [self.rtcEngine bindRemoteVideoView:canvas];
        self.canvasDict[uid] = canvas;

        [self reloadVisibleVideoWrapper];
    }];
#endif
}

- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine didOfflineOfUid:(NSString *)uid channelId:(NSString *)channelId reason:(KuaishouRtcEngineUserOfflineReason)reason {
    NSLog(@"[KuaishouRtcEngine] did remote offline uid = %@, channel = %@", uid, channelId);
    [self.dataMgr removeUserWithUid:uid];
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    KWWS;
    [self.playerContainerView removeRemoteViewWithUid:uid completion:^{
        KWSS;
        // 解绑远端视图
        KuaishouRtcEngineVideoCanvas *canvas = self.canvasDict[uid];
        if (canvas) {
            [self.rtcEngine unBindRemoteVideoView:canvas];
            [self.canvasDict removeObjectForKey:uid];
        }

        [self reloadVisibleVideoWrapper];
    }];
#endif
}

- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine channelId:(NSString *)channelId uid:(NSString *)uid remoteAudioMute:(BOOL)remoteAudioMute {
    NSLog(@"[KuaishouRtcEngine] did remote audio mute = %ld, uid = %@, channel = %@", (long)remoteAudioMute, uid, channelId);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataMgr updateMicphoneStatus:!remoteAudioMute uid:uid];
        [self.playerContainerView remoteMuteAudio:remoteAudioMute uid:uid];
    });
}

- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine channelId:(NSString *)channelId uid:(NSString *)uid remoteVideoMute:(BOOL)remoteVideoMute {
    NSLog(@"[KuaishouRtcEngine] did remote video mute = %ld, uid = %@, channel = %@", (long)remoteVideoMute, uid, channelId);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataMgr updateCameraStatus:!remoteVideoMute uid:uid];
        [self.playerContainerView remoteMuteVideo:remoteVideoMute uid:uid];
    });
}

- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine onRtcStats:(KuaishouRtcEngineChannelStats *)rtcStats {
    self.qosInfo.atxBitrateKbps = rtcStats.txAudioKBitrate;
    self.qosInfo.arxBitrateKbps = rtcStats.rxAudioKBitrate;
    self.qosInfo.vtxBitrateKbps = rtcStats.txVideoKBitrate;
    self.qosInfo.vrxBitrateKbps = rtcStats.rxVideoKBitrate;
    self.qosInfo.txPktLossRate = rtcStats.txPacketLossRate;
    self.qosInfo.rxPktLossRate = rtcStats.rxPacketLossRate;
    self.qosInfo.cpuAppUsage = rtcStats.cpuAppUsage;
    self.qosInfo.cpuTotalUsage = rtcStats.cpuTotalUsage;
    self.qosInfo.memoryAppUsageKb = rtcStats.memoryAppUsageInKbytes;
    self.qosInfo.rtt = rtcStats.rtt;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.consoleView updateQosInfo:self.qosInfo];
    });
}

- (void)kuaishouRtcEngine:(KuaishouRtcEngine *)engine onLocalVideoStats:(KuaishouRtcEngineLocalVideoStats *)localVideoStats {
    // 推流后才会触发此回调，仅本地预览时不会回调
    self.qosInfo.encodedFrameWidth = localVideoStats.encodedFrameWidth;
    self.qosInfo.encodedFrameHeight = localVideoStats.encodedFrameHeight;
    self.qosInfo.captureFrameRate = localVideoStats.captureFrameRate;
    self.qosInfo.targetFrameRate = localVideoStats.targetFrameRate;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.consoleView updateQosInfo:self.qosInfo];
    });
}

#pragma mark - KWRtcRoomDataMgrDelegate
- (void)dataMgrDidUpdateUserInfo:(NSString *)uid {
    [self.memberView reloadData];
    [self.toolbarView updateMemberCount:self.dataMgr.userList.count];
}

#pragma mark - KWRtcRoomBeautyViewDelegate
- (void)beautyValueChangedLightening:(NSInteger)lightening smoothness:(NSInteger)smoothness {
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    self.beautyOptions.lighteningLevel = lightening / 100.0f;
    self.beautyOptions.smoothnessLevel = smoothness / 100.0f;
    NSLog(@"[RoomVc] on beauty change lght = %ld, smth = %ld", (long)lightening, (long)smoothness);
    // 设置美颜参数
    [self.rtcEngine setBeautyEffectOptions:YES options:self.beautyOptions];
#endif
}

#pragma mark - KWRtcRoomInfoViewDelegate
- (void)roomInfoViewDidCopyChannelId:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.roomParam.channelId;
    [self.infoView hideAnimated:YES];
    NSLog(@"[RoomVc] on copy channel id");
    [self.view showToast:@"房间ID已复制"];
}

#pragma mark - KWRtcRoomNavigationBarViewDelegate

- (void)navigationBarView:(KWRtcRoomNavigationBarView *)view onSwitchCamera:(id)sender {
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    if (!self.roomParam.cameraOpen) {
        [self.view showToast:@"摄像头未开启，无法切换"];
        return;
    }
    NSLog(@"[RoomVc] on switch camera");
    [self.rtcEngine switchCamera];
#endif
}

- (void)navigationBarView:(KWRtcRoomNavigationBarView *)view onLeaveChannel:(id)sender {
    NSLog(@"[RoomVc] on leave channel");
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    // 离开频道
    [self.rtcEngine leaveChannel:self.roomParam.channelId leaveBlock:nil];
    [self.rtcEngine destroy];
#endif
    [self.naviBarView stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarView:(KWRtcRoomNavigationBarView *)view onSelectTitle:(id)sender {
    NSLog(@"[RoomVc] on select title");
    [self.infoView showAnimated:YES];
}

#pragma mark - KWRtcRoomToolbarViewDelegate
- (void)toolBarView:(KWRtcRoomToolbarView *)view onMicphone:(id)sender {
    NSLog(@"[RoomVc] on toolbar: micphone");
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    // 开启或关闭麦克风
    if (self.roomParam.micphoneOpen) {
        NSLog(@"[RoomVc] mute local audio cuz user clicked camera button");
        [self.rtcEngine muteLocalAudioStream];
        [self.rtcEngine disableLocalAudio];
        [self.playerContainerView.localVideoWrapperView updateMicAvailable:NO];
    } else {
        NSLog(@"[RoomVc] unmute local audio cuz user clicked camera button");
        [self.rtcEngine unmuteLocalAudioStream];
        [self.rtcEngine enableLocalAudio];
        [self.playerContainerView.localVideoWrapperView updateMicAvailable:YES];
    }
    self.roomParam.micphoneOpen = !self.roomParam.micphoneOpen;
    [self.dataMgr updateMicphoneStatus:self.roomParam.micphoneOpen uid:self.roomParam.userId];
    [self.toolbarView updateMicphoneOpenStatus:self.roomParam.micphoneOpen];
#endif
}

- (void)toolBarView:(KWRtcRoomToolbarView *)view onCamera:(id)sender {
    NSLog(@"[RoomVc] on toolbar: camera");
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    // 开启或关闭摄像头
    if (self.roomParam.cameraOpen) {
        NSLog(@"[RoomVc] mute local video cuz user clicked camera button");
        [self.rtcEngine muteLocalVideoStream:self.roomParam.channelId];
        [self.rtcEngine stopPreview];
        [self.playerContainerView.localVideoWrapperView updateCanvasAvailable:NO];
    } else {
        NSLog(@"[RoomVc] unmute local video cuz user clicked camera button");
        [self.rtcEngine unmuteLocalVideoStream:self.roomParam.channelId];
        [self.rtcEngine startPreview];
        [self.playerContainerView.localVideoWrapperView updateCanvasAvailable:YES];
    }
    self.roomParam.cameraOpen = !self.roomParam.cameraOpen;
    [self.dataMgr updateCameraStatus:self.roomParam.cameraOpen uid:self.roomParam.userId];
    [self.toolbarView updateCameraOpenStatus:self.roomParam.cameraOpen];
#endif
}

- (void)toolBarView:(KWRtcRoomToolbarView *)view onMemberList:(id)sender {
    NSLog(@"[RoomVc] on toolbar: member");
    [self.memberView showAnimated:YES];
}

- (void)toolBarView:(KWRtcRoomToolbarView *)view onBeatuy:(id)sender {
    NSLog(@"[RoomVc] on toolbar: beauty");
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
    if (!self.roomParam.cameraOpen) {
        [self.view showToast:@"摄像头未开启，无法设置美颜"];
        return;
    }
#endif
    [self.beautyView showAnimated:YES];
}

- (void)toolBarView:(KWRtcRoomToolbarView *)view onSetting:(id)sender {
    NSLog(@"[RoomVc] on toolbar: setting");
    KWSettingViewController *vc = [[KWSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - KWRtcPlayerContainerViewDelegate
- (void)playerContainerDidReloadLayout:(BOOL)multiScreen {
    if (self.videoMultiScreenMode != multiScreen) {
        NSLog(@"[RoomVc] multi screen changed = %ld", (long)multiScreen);
        self.videoMultiScreenMode = multiScreen;
    }
    [self reloadVisibleVideoWrapper];
}

- (void)playerContainerDidEndScroll:(BOOL)decelerate {
    [self reloadVisibleVideoWrapper];
}

#pragma mark - Getter
- (KWRtcPlayerContainerView *)playerContainerView {
    if (!_playerContainerView) {
        _playerContainerView = [[KWRtcPlayerContainerView alloc] init];
        _playerContainerView.dataMgr = self.dataMgr;
        _playerContainerView.pageCtrl = self.pageCtrl;
        _playerContainerView.delegate = self;
    }
    return _playerContainerView;
}

- (KWRtcRoomNavigationBarView *)naviBarView {
    if (!_naviBarView) {
        _naviBarView = [[KWRtcRoomNavigationBarView alloc] init];
        _naviBarView.delegate = self;
    }
    return _naviBarView;
}

- (KWRtcRoomToolbarView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [[KWRtcRoomToolbarView alloc] init];
        _toolbarView.delegate = self;
    }
    return _toolbarView;
}

- (KWRtcRoomConsoleView *)consoleView {
    if (!_consoleView) {
        _consoleView = [[KWRtcRoomConsoleView alloc] init];
    }
    return _consoleView;
}

- (KWRtcRoomMemberView *)memberView {
    if (!_memberView) {
        _memberView = [[KWRtcRoomMemberView alloc] init];
        _memberView.userList = self.dataMgr.userList;
    }
    return _memberView;
}

- (KWRtcRoomBeautyView *)beautyView {
    if (!_beautyView) {
        _beautyView = [[KWRtcRoomBeautyView alloc] init];
        _beautyView.delegate = self;
    }
    return _beautyView;
}

- (KWRtcRoomInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[KWRtcRoomInfoView alloc] init];
        _infoView.delegate = self;
    }
    return _infoView;
}

- (KWPageControl *)pageCtrl {
    if (!_pageCtrl) {
        _pageCtrl = [[KWPageControl alloc] init];
        _pageCtrl.numberOfPages = 0;
        _pageCtrl.hidesForSinglePage = YES;
        _pageCtrl.currentPageIndicatorTintColor = KWColorFromHex(0x327DFF);
        _pageCtrl.pageIndicatorTintColor = KWColorFromHexA(0x000000, 0.1);
        _pageCtrl.transform = CGAffineTransformMakeScale(0.7, 0.7);
        _pageCtrl.currentPageIndicatorImage = KWImage(@"img_pagectrl_cur");
        _pageCtrl.pageIndicatorImage = KWImage(@"img_pagectrl_hold");
    }
    return _pageCtrl;
}

- (KWRtcRoomDataMgr *)dataMgr {
    if (!_dataMgr) {
        _dataMgr = [[KWRtcRoomDataMgr alloc] init];
        _dataMgr.delegate = self;
    }
    return _dataMgr;
}

- (KWRtcQosInfo *)qosInfo {
    if (!_qosInfo) {
        _qosInfo = [[KWRtcQosInfo alloc] init];
    }
    return _qosInfo;
}

#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
- (KuaishouRtcEngineBeautyOptions *)beautyOptions {
    if (!_beautyOptions) {
        _beautyOptions = [[KuaishouRtcEngineBeautyOptions alloc] init];
    }
    return _beautyOptions;
}

- (NSMutableDictionary *)canvasDict {
    if (!_canvasDict) {
        _canvasDict = [[NSMutableDictionary alloc] init];
    }
    return _canvasDict;
}

#endif

@end
