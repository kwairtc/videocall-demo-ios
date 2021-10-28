//
//  KWRtcDemoUI.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/10/26.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWRtcDemoUI.h"
#import "UIButton+KWExt.h"
#import "KWRtcUser.h"
#import "KWRtcQosInfo.h"

#define ROOMINFO_CONTAINER_HEIGHT 258
#define ROOMINFO_CONTAINER_MARGIN 0
#define BEAUTY_CONTAINER_HEIGHT 183

@interface KWRtcRoomNavigationBarView ()

@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) UIButton *audioRouteButton;
@property (nonatomic, strong) UIButton *leaveChannelButton;
@property (nonatomic, strong) UILabel *channelTitleLabel;
@property (nonatomic, strong) UILabel *channelDetailLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger joinDuration;

@end

@implementation KWRtcRoomNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KWColorFromHex(0xFFFFFF);
        self.joinDuration = 0;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.switchCameraButton];
    [self addSubview:self.audioRouteButton];
    [self addSubview:self.leaveChannelButton];
    [self addSubview:self.channelTitleLabel];
    [self addSubview:self.channelDetailLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.titleButton];

    [self.switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-4);
        make.width.height.mas_equalTo(44);
    }];

    [self.audioRouteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.width.height.equalTo(self.switchCameraButton);
        make.left.equalTo(self.switchCameraButton.mas_right).offset(4);
    }];

    [self.leaveChannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-6);
        make.right.equalTo(self).offset(-20);
        make.width.height.mas_equalTo(40);
    }];

    [self.channelTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-3);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.channelDetailLabel.mas_top).offset(-1);
    }];

    [self.channelDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self).offset(-4);
    }];

    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.channelTitleLabel);
        make.left.equalTo(self.channelTitleLabel.mas_right).offset(6);
        make.width.height.mas_equalTo(10);
    }];

    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.channelTitleLabel);
        make.top.equalTo(self.channelTitleLabel);
        make.right.equalTo(self.arrowImageView);
        make.bottom.equalTo(self.channelDetailLabel);
    }];
}

+ (CGFloat)defaultHeight {
    return RTC_ROOM_NAVIBAR_HEIGHT;
}

- (void)updateChannelId:(NSString *)channelId {
    self.channelTitleLabel.text = [NSString stringWithFormat:@"ID: %@", channelId];
}

- (void)startTimer {
    if (!self.timer) {
        KWWS;
        self.timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
            KWSS;
            self.joinDuration = self.joinDuration + 1;

            NSInteger hour = self.joinDuration / 3600;
            NSInteger minute = (self.joinDuration % 3600) / 60;
            NSInteger second = self.joinDuration % 60;
            NSString *timeFmt = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)minute, (long)second];
            self.channelDetailLabel.text = [NSString stringWithFormat:@"%@", timeFmt];
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    self.joinDuration = 0;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Action
- (void)onAudioRoute:(id)sender {
    if ([self.delegate respondsToSelector:@selector(navigationBarView:onAudioRoute:)]) {
        [self.delegate navigationBarView:self onAudioRoute:sender];
    }
}

- (void)onSwitchCamera:(id)sender {
    if ([self.delegate respondsToSelector:@selector(navigationBarView:onSwitchCamera:)]) {
        [self.delegate navigationBarView:self onSwitchCamera:sender];
    }
}

- (void)onLeaveChannel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(navigationBarView:onLeaveChannel:)]) {
        [self.delegate navigationBarView:self onLeaveChannel:sender];
    }
}

- (void)onSelectTitle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(navigationBarView:onSelectTitle:)]) {
        [self.delegate navigationBarView:self onSelectTitle:sender];
    }
}

#pragma mark - Getter
- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCameraButton setImage:KWImage(@"btn_camera_switch") forState:UIControlStateNormal];
        [_switchCameraButton addTarget:self action:@selector(onSwitchCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraButton;
}

- (UIButton *)audioRouteButton {
    if (!_audioRouteButton) {
        _audioRouteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioRouteButton setImage:KWImage(@"btn_audio_route") forState:UIControlStateNormal];
        [_audioRouteButton addTarget:self action:@selector(onAudioRoute:) forControlEvents:UIControlEventTouchUpInside];
        _audioRouteButton.hidden = YES;
    }
    return _audioRouteButton;
}

- (UIButton *)leaveChannelButton {
    if (!_leaveChannelButton) {
        _leaveChannelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leaveChannelButton setImage:KWImage(@"btn_shut_down") forState:UIControlStateNormal];
        [_leaveChannelButton addTarget:self action:@selector(onLeaveChannel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leaveChannelButton;
}

- (UILabel *)channelTitleLabel {
    if (!_channelTitleLabel) {
        _channelTitleLabel = [[UILabel alloc] init];
        _channelTitleLabel.font = [UIFont systemFontOfSize:16];
        _channelTitleLabel.textColor = KWColorFromHex(0x000000);
        _channelTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _channelTitleLabel;
}

- (UILabel *)channelDetailLabel {
    if (!_channelDetailLabel) {
        _channelDetailLabel = [[UILabel alloc] init];
        _channelDetailLabel.font = [UIFont systemFontOfSize:12];
        _channelDetailLabel.textColor = KWColorFromHexA(0x000000, 0.6);
        _channelDetailLabel.textAlignment = NSTextAlignmentCenter;
        _channelDetailLabel.text = @"00:00:00";
    }
    return _channelDetailLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView.image = KWImage(@"icon_arrow_down");
    }
    return _arrowImageView;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton addTarget:self action:@selector(onSelectTitle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

@end


@interface KWRtcRoomToolbarView ()

@property (nonatomic, strong) UIButton *micphoneButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *memberButton;
@property (nonatomic, strong) UIButton *beatuyButton;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UILabel *memberCountLabel;

@end

@implementation KWRtcRoomToolbarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KWColorFromHex(0xFFFFFF);
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.micphoneButton];
    [self addSubview:self.cameraButton];
    [self addSubview:self.memberButton];
    [self addSubview:self.beatuyButton];
    [self addSubview:self.settingButton];
    [self.memberButton addSubview:self.memberCountLabel];

    CGFloat buttonWidth = floor((KWScreenMinSide - 10) / 5.0f);

    [self.micphoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self.cameraButton.mas_left);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(74);
    }];

    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self.memberButton.mas_left);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(74);
    }];

    [self.memberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(74);
    }];

    [self.beatuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.memberButton.mas_right);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(74);
    }];

    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.beatuyButton.mas_right);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(74);
    }];

    [self.memberCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memberButton.imageView).offset(3);
        make.right.equalTo(self.memberButton.imageView).offset(0);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
}

+ (CGFloat)defaultHeight {
    return RTC_ROOM_TOOLBAR_HEIGHT;
}

- (void)updateMicphoneOpenStatus:(BOOL)open {
    if (open) {
        [self.micphoneButton setImage:KWImage(@"btn_mic_on") forState:UIControlStateNormal];
    } else {
        [self.micphoneButton setImage:KWImage(@"btn_mic_off") forState:UIControlStateNormal];
    }
    [self.micphoneButton alignmentCenterWithSpacing:1];
}

- (void)updateCameraOpenStatus:(BOOL)open {
    if (open) {
        [self.cameraButton setImage:KWImage(@"btn_camera_on") forState:UIControlStateNormal];
    } else {
        [self.cameraButton setImage:KWImage(@"btn_camera_off") forState:UIControlStateNormal];
    }
    [self.cameraButton alignmentCenterWithSpacing:1];
}

- (void)refreshUI {
    [self.micphoneButton alignmentCenterWithSpacing:1];
    [self.cameraButton alignmentCenterWithSpacing:1];
    [self.memberButton alignmentCenterWithSpacing:1];
    [self.beatuyButton alignmentCenterWithSpacing:1];
    [self.settingButton alignmentCenterWithSpacing:1];
}

- (void)updateMemberCount:(NSInteger)count {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.memberCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    });
}

#pragma mark - Action
- (void)onMicphone:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toolBarView:onMicphone:)]) {
        [self.delegate toolBarView:self onMicphone:sender];
    }
}

- (void)onCamera:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toolBarView:onCamera:)]) {
        [self.delegate toolBarView:self onCamera:sender];
    }
}

- (void)onMember:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toolBarView:onMemberList:)]) {
        [self.delegate toolBarView:self onMemberList:sender];
    }
}

- (void)onBeatuy:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toolBarView:onBeatuy:)]) {
        [self.delegate toolBarView:self onBeatuy:sender];
    }
}

- (void)onSetting:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toolBarView:onSetting:)]) {
        [self.delegate toolBarView:self onSetting:sender];
    }
}

#pragma mark - Getter
- (UIButton *)micphoneButton {
    if (!_micphoneButton) {
        _micphoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _micphoneButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_micphoneButton setTitleColor:KWColorFromHex(0x000000) forState:UIControlStateNormal];
        [_micphoneButton setTitle:@"静音" forState:UIControlStateNormal];
        [_micphoneButton setImage:KWImage(@"btn_mic_on") forState:UIControlStateNormal];
        [_micphoneButton addTarget:self action:@selector(onMicphone:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _micphoneButton;
}

- (UIButton *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_cameraButton setTitleColor:KWColorFromHex(0x000000) forState:UIControlStateNormal];
        [_cameraButton setTitle:@"摄像头" forState:UIControlStateNormal];
        [_cameraButton setImage:KWImage(@"btn_camera_on") forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(onCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

- (UIButton *)memberButton {
    if (!_memberButton) {
        _memberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _memberButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_memberButton setTitleColor:KWColorFromHex(0x000000) forState:UIControlStateNormal];
        [_memberButton setTitle:@"成员" forState:UIControlStateNormal];
        [_memberButton setImage:KWImage(@"btn_member") forState:UIControlStateNormal];
        [_memberButton addTarget:self action:@selector(onMember:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _memberButton;
}

- (UIButton *)beatuyButton {
    if (!_beatuyButton) {
        _beatuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _beatuyButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_beatuyButton setTitleColor:KWColorFromHex(0x000000) forState:UIControlStateNormal];
        [_beatuyButton setTitle:@"美颜" forState:UIControlStateNormal];
        [_beatuyButton setImage:KWImage(@"btn_beauty") forState:UIControlStateNormal];
        [_beatuyButton addTarget:self action:@selector(onBeatuy:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beatuyButton;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_settingButton setTitleColor:KWColorFromHex(0x000000) forState:UIControlStateNormal];
        [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingButton setImage:KWImage(@"btn_setting") forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (UILabel *)memberCountLabel {
    if (!_memberCountLabel) {
        _memberCountLabel = [[UILabel alloc] init];
        _memberCountLabel.font = [UIFont boldSystemFontOfSize:10];
        _memberCountLabel.textColor = KWColorFromHex(0x666666);
        _memberCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _memberCountLabel;
}

@end


@interface KWRtcRoomInfoView ()

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *dragBarView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *channelIdTitleLabel;
@property (nonatomic, strong) UILabel *channelIdDetailLabel;
@property (nonatomic, strong) UIButton *smallCopyButton;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation KWRtcRoomInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.bgButton];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.dragBarView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.channelIdTitleLabel];
    [self.containerView addSubview:self.channelIdDetailLabel];
    [self.containerView addSubview:self.smallCopyButton];
    [self.containerView addSubview:self.actionButton];

    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ROOMINFO_CONTAINER_MARGIN);
        make.right.equalTo(self).offset(-ROOMINFO_CONTAINER_MARGIN);
        make.bottom.equalTo(self).offset(ROOMINFO_CONTAINER_HEIGHT);
        make.height.mas_equalTo(ROOMINFO_CONTAINER_HEIGHT);
    }];

    [self.dragBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(8);
        make.centerX.equalTo(self.containerView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(4);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(36);
        make.top.equalTo(self.containerView).offset(32);
        make.height.mas_equalTo(28);
    }];

    [self.channelIdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(36);
        make.height.mas_equalTo(20);
    }];

    [self.channelIdDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(120);
        make.top.equalTo(self.channelIdTitleLabel);
        make.height.mas_equalTo(20);
    }];

    [self.smallCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.channelIdDetailLabel.mas_right);
        make.centerY.equalTo(self.channelIdDetailLabel);
        make.width.height.mas_equalTo(40);
    }];

    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(12);
        make.right.equalTo(self.containerView).offset(-12);
        make.bottom.equalTo(self.containerView).offset(-36);
        make.height.mas_equalTo(52);
    }];
}

- (void)showAnimated:(BOOL)animated {
    self.hidden = NO;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:(animated ? 0.3 : 0) animations:^{
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)hideAnimated:(BOOL)animated {
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:(animated ? 0.3 : 0) animations:^{
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(ROOMINFO_CONTAINER_HEIGHT);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)onClose:(id)sender {
    [self hideAnimated:YES];
}

- (void)updateChannelId:(NSString *)channelId {
    self.channelIdDetailLabel.text = channelId;
}

- (void)onCopyChannelId:(id)sender {
    if ([self.delegate respondsToSelector:@selector(roomInfoViewDidCopyChannelId:)]) {
        [self.delegate roomInfoViewDidCopyChannelId:sender];
    }
}

#pragma mark - Getter
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = KWColorFromHex(0xFFFFFF);
        UIBezierPath *bzPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, KWScreenMinSide - ROOMINFO_CONTAINER_MARGIN * 2, ROOMINFO_CONTAINER_HEIGHT) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, KWScreenMinSide - ROOMINFO_CONTAINER_MARGIN * 2, ROOMINFO_CONTAINER_HEIGHT);
        maskLayer.path = bzPath.CGPath;
        _containerView.layer.mask = maskLayer;
    }
    return _containerView;
}

- (UIView *)dragBarView {
    if (!_dragBarView) {
        _dragBarView = [[UIView alloc] init];
        _dragBarView.backgroundColor = KWColorFromHexA(0x000000, 0.2);
        _dragBarView.layer.cornerRadius = 2.0;
        _dragBarView.layer.masksToBounds = YES;
    }
    return _dragBarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = KWColorFromHexA(0x000000, 0.9);
        _titleLabel.text = @"房间信息";
    }
    return _titleLabel;
}

- (UILabel *)channelIdTitleLabel {
    if (!_channelIdTitleLabel) {
        _channelIdTitleLabel = [[UILabel alloc] init];
        _channelIdTitleLabel.font = [UIFont systemFontOfSize:14];
        _channelIdTitleLabel.textColor = KWColorFromHexA(0x000000, 0.5);
        _channelIdTitleLabel.text = @"房间 ID：";
    }
    return _channelIdTitleLabel;
}

- (UILabel *)channelIdDetailLabel {
    if (!_channelIdDetailLabel) {
        _channelIdDetailLabel = [[UILabel alloc] init];
        _channelIdDetailLabel.font = [UIFont systemFontOfSize:14];
        _channelIdDetailLabel.textColor = KWColorFromHex(0x000000);
    }
    return _channelIdDetailLabel;
}

- (UIButton *)smallCopyButton {
    if (!_smallCopyButton) {
        _smallCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_smallCopyButton setImage:KWImage(@"btn_copy_id") forState:UIControlStateNormal];
        [_smallCopyButton addTarget:self action:@selector(onCopyChannelId:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smallCopyButton;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.layer.cornerRadius = 4.0f;
        _actionButton.layer.masksToBounds = YES;
        [_actionButton setBackgroundImage:[KWCommonUtil imageWithColor:KWColorFromHex(0x327DFF)] forState:UIControlStateNormal];
        [_actionButton setBackgroundImage:[KWCommonUtil imageWithColor:KWColorFromHexA(0x327DFF, 0.2)] forState:UIControlStateDisabled];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_actionButton setTitleColor:KWColorFromHex(0xFFFFFF) forState:UIControlStateNormal];
        [_actionButton setTitle:@"复制房间ID" forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(onCopyChannelId:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

@end

@interface KWSlider : UISlider

@end

@implementation KWSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 11, bounds.size.width, 6);
}

@end

@interface KWRtcRoomBeautyView ()

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *smoothnessLabel;
@property (nonatomic, strong) UILabel *lighteningLabel;
@property (nonatomic, strong) KWSlider *smoothnessSlider;
@property (nonatomic, strong) KWSlider *lighteningSlider;

@end

@implementation KWRtcRoomBeautyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.bgButton];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.smoothnessLabel];
    [self.containerView addSubview:self.smoothnessSlider];
    [self.containerView addSubview:self.lighteningLabel];
    [self.containerView addSubview:self.lighteningSlider];

    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-RTC_ROOM_TOOLBAR_HEIGHT);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(BEAUTY_CONTAINER_HEIGHT);
    }];

    [self.smoothnessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(36);
        make.top.equalTo(self.containerView).offset(28);
        make.height.mas_equalTo(20);
    }];

    [self.lighteningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smoothnessLabel);
        make.top.equalTo(self.smoothnessLabel.mas_bottom).offset(50);
        make.height.mas_equalTo(20);
    }];

    [self.smoothnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(36+2);
        make.right.equalTo(self.containerView).offset(-36-2);
        make.top.equalTo(self.smoothnessLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(28);
    }];

    [self.lighteningSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.smoothnessSlider);
        make.top.equalTo(self.lighteningLabel.mas_bottom).offset(8);
    }];
}

- (void)loadDefaultValue {
    self.smoothnessSlider.value = 50;
    self.lighteningSlider.value = 50;

    if ([self.delegate respondsToSelector:@selector(beautyValueChangedLightening:smoothness:)]) {
        [self.delegate beautyValueChangedLightening:self.lighteningSlider.value smoothness:self.smoothnessSlider.value];
    }
}

- (void)showAnimated:(BOOL)animated {
    self.hidden = NO;
    self.alpha = 0.0f;
    [UIView animateWithDuration:(animated ? 0.3 : 0) animations:^{
        self.alpha = 1.0f;
    }];
}

- (void)hideAnimated:(BOOL)animated {
    self.alpha = 1.0f;
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)onClose:(id)sender {
    [self hideAnimated:YES];
}

- (void)onSliderValueChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(beautyValueChangedLightening:smoothness:)]) {
        [self.delegate beautyValueChangedLightening:self.lighteningSlider.value smoothness:self.smoothnessSlider.value];
    }
}

#pragma mark - Getter
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = KWColorFromHexA(0xFFFFFF, 0.75);
        UIBezierPath *bzPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, KWScreenMinSide, BEAUTY_CONTAINER_HEIGHT) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, KWScreenMinSide, BEAUTY_CONTAINER_HEIGHT);
        maskLayer.path = bzPath.CGPath;
        _containerView.layer.mask = maskLayer;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = maskLayer.frame;
        [_containerView addSubview:blurView];
    }
    return _containerView;
}

- (UILabel *)smoothnessLabel {
    if (!_smoothnessLabel) {
        _smoothnessLabel = [[UILabel alloc] init];
        _smoothnessLabel.font = [UIFont systemFontOfSize:14];
        _smoothnessLabel.textColor = KWColorFromHexA(0x000000, 0.8);
        _smoothnessLabel.text = @"磨皮";
    }
    return _smoothnessLabel;
}

- (UILabel *)lighteningLabel {
    if (!_lighteningLabel) {
        _lighteningLabel = [[UILabel alloc] init];
        _lighteningLabel.font = [UIFont systemFontOfSize:14];
        _lighteningLabel.textColor = KWColorFromHexA(0x000000, 0.8);
        _lighteningLabel.text = @"美白";
    }
    return _lighteningLabel;
}

- (KWSlider *)smoothnessSlider {
    if (!_smoothnessSlider) {
        _smoothnessSlider = [[KWSlider alloc] init];
        _smoothnessSlider.minimumTrackTintColor = KWColorFromHex(0x327DFF);
        _smoothnessSlider.maximumTrackTintColor = KWColorFromHexA(0x000000, 0.1);
        [_smoothnessSlider setThumbImage:KWImage(@"icon_slider_thumb") forState:UIControlStateNormal];
        _smoothnessSlider.minimumValue = 0;
        _smoothnessSlider.maximumValue = 100;
        [_smoothnessSlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _smoothnessSlider;
}

- (KWSlider *)lighteningSlider {
    if (!_lighteningSlider) {
        _lighteningSlider = [[KWSlider alloc] init];
        _lighteningSlider.minimumTrackTintColor = KWColorFromHex(0x327DFF);
        _lighteningSlider.maximumTrackTintColor = KWColorFromHexA(0x000000, 0.1);
        [_lighteningSlider setThumbImage:KWImage(@"icon_slider_thumb") forState:UIControlStateNormal];
        _lighteningSlider.minimumValue = 0;
        _lighteningSlider.maximumValue = 100;
        [_lighteningSlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _lighteningSlider;
}

@end


#define MEMBER_CONTAINER_HEIGHT (KWScreenMaxSide - 102)
#define MEMBER_CONTAINER_MARGIN 0
#define MEMBER_AVATAR_SIZE 32

#pragma mark -
#pragma mark KWRtcRoomMemberTableViewCell
@interface KWRtcRoomMemberTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, strong) UILabel *avatarLabel;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *identityLabel;
@property (nonatomic, strong) UIButton *micphoneButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIView *separatorLineView;

+ (CGFloat)defaultHeight;
- (void)updateWithData:(nullable KWRtcUser *)user;

@end

@implementation KWRtcRoomMemberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = KWColorFromHex(0xFFFFFF);
        self.contentView.backgroundColor = KWColorFromHex(0xFFFFFF);
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self.contentView addSubview:self.avatarView];
    [self.avatarView addSubview:self.avatarLabel];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.identityLabel];
    [self.contentView addSubview:self.micphoneButton];
    [self.contentView addSubview:self.cameraButton];
    [self.contentView addSubview:self.separatorLineView];

    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(MEMBER_AVATAR_SIZE);
    }];

    [self.avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView);
        make.left.equalTo(self.avatarView).offset(2);
        make.right.equalTo(self.avatarView).offset(-2);
    }];

    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).offset(12);
        make.centerY.equalTo(self.avatarView);
        make.height.mas_equalTo(20);
    }];

    [self.identityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknameLabel.mas_right).offset(4);
        make.centerY.equalTo(self.nicknameLabel);
        make.height.mas_equalTo(20);
        make.right.lessThanOrEqualTo(self.micphoneButton.mas_left).offset(-12).priorityHigh();
    }];

    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(28);
    }];

    [self.micphoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cameraButton.mas_left).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(28);
    }];

    [self.separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];

    [self.identityLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.identityLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.nicknameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.cameraButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.cameraButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.micphoneButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.micphoneButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

+ (CGFloat)defaultHeight {
    return 48.0f;
}

- (void)updateWithData:(nullable KWRtcUser *)user {
    if (!user) {
        self.avatarLabel.text = @"";
        self.nicknameLabel.text = @"";
        self.identityLabel.text = @"";
        return;
    }

    self.avatarLabel.text = user.userId;
    self.nicknameLabel.text = user.userId;
    if (user.identity == KWRtcUserIdentityMyself) {
        self.identityLabel.text = @"(我)";
    } else {
        self.identityLabel.text = nil;
    }
    [self.micphoneButton setImage:KWImage(user.openMicphone ? @"btn_small_mic_on" : @"btn_small_mic_off") forState:UIControlStateNormal];
    [self.cameraButton setImage:KWImage(user.openCamera ? @"btn_small_camera_on" : @"btn_small_camera_off") forState:UIControlStateNormal];
}

#pragma mark - Getter
- (UIView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIView alloc] init];
        _avatarView.layer.cornerRadius = MEMBER_AVATAR_SIZE * 0.5f;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.backgroundColor = KWColorFromHex(0x327DFF);
    }
    return _avatarView;
}

- (UILabel *)avatarLabel {
    if (!_avatarLabel) {
        _avatarLabel = [[UILabel alloc] init];
        _avatarLabel.font = [UIFont systemFontOfSize:10];
        _avatarLabel.textColor = KWColorFromHex(0xFFFFFF);
        _avatarLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _avatarLabel;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.font = [UIFont systemFontOfSize:14];
        _nicknameLabel.textColor = KWColorFromHexA(0x000000, 0.9);
    }
    return _nicknameLabel;
}

- (UILabel *)identityLabel {
    if (!_identityLabel) {
        _identityLabel = [[UILabel alloc] init];
        _identityLabel.font = [UIFont systemFontOfSize:14];
        _identityLabel.textColor = KWColorFromHexA(0x000000, 0.9);
    }
    return _identityLabel;
}

- (UIButton *)micphoneButton {
    if (!_micphoneButton) {
        _micphoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _micphoneButton;
}

- (UIButton *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _cameraButton;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc] init];
        _separatorLineView.backgroundColor = KWColorFromHexA(0x000000, 0.1);
    }
    return _separatorLineView;
}

@end

#pragma mark -
#pragma mark KWRtcRoomMemberView

@interface KWRtcRoomMemberView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *dragBarView;
@property (nonatomic, strong) UIView *headerGestureView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorLineView;
@property (nonatomic, strong) UITableView *memberListTableView;

@end

@implementation KWRtcRoomMemberView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.bgButton];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.dragBarView];
    [self.containerView addSubview:self.headerGestureView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.memberListTableView];
    [self.containerView addSubview:self.separatorLineView];

    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MEMBER_CONTAINER_MARGIN);
        make.right.equalTo(self).offset(-MEMBER_CONTAINER_MARGIN);
        make.bottom.equalTo(self).offset(MEMBER_CONTAINER_HEIGHT);
        make.height.mas_equalTo(MEMBER_CONTAINER_HEIGHT);
    }];

    [self.dragBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(8);
        make.centerX.equalTo(self.containerView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(4);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(28);
        make.left.equalTo(self.containerView).offset(20);
        make.height.mas_equalTo(24);
    }];

    [self.memberListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView).offset(-[KWCommonUtil iPhoneXPortraitSafeAreaInsets].bottom - 12);
    }];

    [self.headerGestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
        make.bottom.equalTo(self.memberListTableView.mas_top).offset(0);
    }];

    [self.separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.bottom.equalTo(self.memberListTableView.mas_top);
        make.height.mas_equalTo(1);
    }];
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLabel.text = [NSString stringWithFormat:@"成员 (%ld)", (long)self.userList.count];
        [self.memberListTableView reloadData];
    });
}

- (void)showAnimated:(BOOL)animated {
    NSLog(@"[MemberView] on show");
    self.hidden = NO;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:(animated ? 0.3 : 0) animations:^{
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)hideAnimated:(BOOL)animated {
    NSLog(@"[MemberView] on hide");
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:(animated ? 0.3 : 0) animations:^{
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(MEMBER_CONTAINER_HEIGHT);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)onClose:(id)sender {
    [self hideAnimated:YES];
}

- (void)onHeaderSwipe:(id)sender {
    [self hideAnimated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count;
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWRtcRoomMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KWRtcRoomMemberTableViewCell class])];
    if (!cell) {
        cell = [[KWRtcRoomMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([KWRtcRoomMemberTableViewCell class])];
    }
    if (indexPath.row < self.userList.count) {
        KWRtcUser *user = self.userList[indexPath.row];
        [cell updateWithData:user];
    } else {
        [cell updateWithData:nil];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KWRtcRoomMemberTableViewCell defaultHeight];
}

#pragma mark - Getter
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = KWColorFromHex(0xFFFFFF);
        UIBezierPath *bzPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, KWScreenMinSide - MEMBER_CONTAINER_MARGIN * 2, MEMBER_CONTAINER_HEIGHT) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, KWScreenMinSide - MEMBER_CONTAINER_MARGIN * 2, MEMBER_CONTAINER_HEIGHT);
        maskLayer.path = bzPath.CGPath;
        _containerView.layer.mask = maskLayer;
    }
    return _containerView;
}

- (UIView *)dragBarView {
    if (!_dragBarView) {
        _dragBarView = [[UIView alloc] init];
        _dragBarView.backgroundColor = KWColorFromHexA(0x000000, 0.2);
        _dragBarView.layer.cornerRadius = 2.0;
        _dragBarView.layer.masksToBounds = YES;
    }
    return _dragBarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = KWColorFromHexA(0x000000, 0.9);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"成员";
    }
    return _titleLabel;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc] init];
        _separatorLineView.backgroundColor = KWColorFromHexA(0x000000, 0.1);
    }
    return _separatorLineView;
}

- (UITableView *)memberListTableView {
    if (!_memberListTableView) {
        _memberListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _memberListTableView.backgroundColor = [UIColor clearColor];
        _memberListTableView.delegate = self;
        _memberListTableView.dataSource = self;
        _memberListTableView.showsVerticalScrollIndicator = NO;
        _memberListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _memberListTableView;
}

- (UIView *)headerGestureView {
    if (!_headerGestureView) {
        _headerGestureView = [[UIView alloc] init];
        UISwipeGestureRecognizer *gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderSwipe:)];
        gr.direction = UISwipeGestureRecognizerDirectionDown;
        [_headerGestureView addGestureRecognizer:gr];
    }
    return _headerGestureView;
}

@end


#define CONSOLE_ROW_HEIGHT 20
#define CONSOLE_ROW_INNER_MARGIN 6
#define CONSOLE_ROW_OUTER_MARGIN 16
#define CONSOLE_ROW_COUNT 7
#define CONSOLE_TOTAL_HEIGHT (CONSOLE_ROW_OUTER_MARGIN * 2 + (CONSOLE_ROW_HEIGHT + CONSOLE_ROW_INNER_MARGIN) * CONSOLE_ROW_COUNT - CONSOLE_ROW_INNER_MARGIN)

@interface KWRtcRoomConsoleView ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *cpuTitleLabel;
@property (nonatomic, strong) UILabel *memoryTitleLabel;
@property (nonatomic, strong) UILabel *rttTitleLabel;
@property (nonatomic, strong) UILabel *resolutionTitleLabel;
@property (nonatomic, strong) UILabel *videoTitleLabel;
@property (nonatomic, strong) UILabel *audioTitleLabel;
@property (nonatomic, strong) UILabel *pktLossTitleLabel;

@property (nonatomic, strong) UILabel *cpuDetailLabel;
@property (nonatomic, strong) UILabel *memoryDetailLabel;
@property (nonatomic, strong) UILabel *rttDetailLabel;
@property (nonatomic, strong) UILabel *resolutionDetailLabel;
@property (nonatomic, strong) UILabel *videoDetailLabel;
@property (nonatomic, strong) UILabel *audioDetailLabel;
@property (nonatomic, strong) UILabel *pktLossDetailLabel;

@end

@implementation KWRtcRoomConsoleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KWColorFromHexA(0x000000, 0.5);
        [self buildUI];
        [self updateQosInfo:nil];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.containerView];
    [self addSubview:self.cpuTitleLabel];
    [self addSubview:self.memoryTitleLabel];
    [self addSubview:self.rttTitleLabel];
    [self addSubview:self.resolutionTitleLabel];
    [self addSubview:self.videoTitleLabel];
    [self addSubview:self.audioTitleLabel];
    [self addSubview:self.pktLossTitleLabel];
    [self addSubview:self.cpuDetailLabel];
    [self addSubview:self.memoryDetailLabel];
    [self addSubview:self.rttDetailLabel];
    [self addSubview:self.resolutionDetailLabel];
    [self addSubview:self.videoDetailLabel];
    [self addSubview:self.audioDetailLabel];
    [self addSubview:self.pktLossDetailLabel];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.cpuTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(CONSOLE_ROW_OUTER_MARGIN);
        make.left.equalTo(self).offset(8);
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(CONSOLE_ROW_HEIGHT);
    }];

    [self.memoryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cpuTitleLabel.mas_bottom).offset(CONSOLE_ROW_INNER_MARGIN);
        make.left.width.height.equalTo(self.cpuTitleLabel);
    }];

    [self.rttTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memoryTitleLabel.mas_bottom).offset(CONSOLE_ROW_INNER_MARGIN);
        make.left.width.height.equalTo(self.cpuTitleLabel);
    }];

    [self.resolutionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rttTitleLabel.mas_bottom).offset(CONSOLE_ROW_INNER_MARGIN);
        make.left.width.height.equalTo(self.cpuTitleLabel);
    }];

    [self.videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resolutionTitleLabel.mas_bottom).offset(CONSOLE_ROW_INNER_MARGIN);
        make.left.width.height.equalTo(self.cpuTitleLabel);
    }];

    [self.audioTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoTitleLabel.mas_bottom).offset(CONSOLE_ROW_INNER_MARGIN);
        make.left.width.height.equalTo(self.cpuTitleLabel);
    }];

    [self.pktLossTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioTitleLabel.mas_bottom).offset(CONSOLE_ROW_INNER_MARGIN);
        make.left.width.height.equalTo(self.cpuTitleLabel);
    }];

    [self.cpuDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpuTitleLabel.mas_right).offset(10);
        make.centerY.height.equalTo(self.cpuTitleLabel);
        make.right.equalTo(self).offset(-8);
    }];

    [self.memoryDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpuDetailLabel);
        make.centerY.height.equalTo(self.memoryTitleLabel);
        make.right.equalTo(self).offset(-8);
    }];

    [self.rttDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpuDetailLabel);
        make.centerY.height.equalTo(self.rttTitleLabel);
        make.right.equalTo(self).offset(-8);
    }];

    [self.resolutionDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpuDetailLabel);
        make.centerY.height.equalTo(self.resolutionTitleLabel);
        make.right.equalTo(self).offset(-8);
    }];

    [self.videoDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpuDetailLabel);
        make.centerY.height.equalTo(self.videoTitleLabel);
        make.right.equalTo(self).offset(-8);
    }];

    [self.audioDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpuDetailLabel);
        make.centerY.height.equalTo(self.audioTitleLabel);
        make.right.equalTo(self).offset(-8);
    }];

    [self.pktLossDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cpuDetailLabel);
        make.centerY.height.equalTo(self.pktLossTitleLabel);
        make.right.equalTo(self).offset(-8);
    }];
}

+ (CGFloat)defaultWidth {
    return KWScreenMinSide;
}

+ (CGFloat)defaultHeight {
    return CONSOLE_TOTAL_HEIGHT;
}

- (void)updateQosInfo:(nullable KWRtcQosInfo *)info {
    if (!info) {
        self.cpuDetailLabel.text = @"-";
        self.memoryDetailLabel.text = @"-";
        self.rttDetailLabel.text = @"-";
        self.resolutionDetailLabel.text = @"-";
        self.videoDetailLabel.text = @"-";
        self.audioDetailLabel.text = @"-";
        self.pktLossDetailLabel.text = @"-";
        return;
    }
    self.cpuDetailLabel.text = [NSString stringWithFormat:@"%ld%%/%ld%%", (long)info.cpuAppUsage, (long)info.cpuTotalUsage];
    self.memoryDetailLabel.text = [NSString stringWithFormat:@"%.2fMB", (info.memoryAppUsageKb / 1024.0f)];
    self.rttDetailLabel.text = [NSString stringWithFormat:@"%@", info.rttString];
    self.resolutionDetailLabel.text = [NSString stringWithFormat:@"%ldx%ld %ldfps", (long)info.encodedFrameWidth, (long)info.encodedFrameHeight, (long)info.captureFrameRate];
    self.videoDetailLabel.text = [NSString stringWithFormat:@"%ldkbps/%ldkbps", (long)info.vtxBitrateKbps, (long)info.vrxBitrateKbps];
    self.audioDetailLabel.text = [NSString stringWithFormat:@"%ldkbps/%ldkbps", (long)info.atxBitrateKbps, (long)info.arxBitrateKbps];
    self.pktLossDetailLabel.text = [NSString stringWithFormat:@"%@/%@", info.txPktLossRateString, info.rxPktLossRateString];
}

#pragma mark - Getter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = KWColorFromHexA(0xFFFFFF, 0.75);
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = CGRectMake(0, 0, KWScreenMinSide, CONSOLE_TOTAL_HEIGHT);
        [_containerView addSubview:blurView];
    }
    return _containerView;
}

- (UILabel *)cpuTitleLabel {
    if (!_cpuTitleLabel) {
        _cpuTitleLabel = [[UILabel alloc] init];
        _cpuTitleLabel.font = [UIFont systemFontOfSize:14];
        _cpuTitleLabel.textColor = KWColorFromHexA(0x000000, 0.5);
        _cpuTitleLabel.textAlignment = NSTextAlignmentRight;
        _cpuTitleLabel.text = @"CPU App/Total:";
    }
    return _cpuTitleLabel;
}

- (UILabel *)memoryTitleLabel {
    if (!_memoryTitleLabel) {
        _memoryTitleLabel = [[UILabel alloc] init];
        _memoryTitleLabel.font = [UIFont systemFontOfSize:14];
        _memoryTitleLabel.textColor = KWColorFromHexA(0x000000, 0.5);
        _memoryTitleLabel.textAlignment = NSTextAlignmentRight;
        _memoryTitleLabel.text = @"Memery:";
    }
    return _memoryTitleLabel;
}

- (UILabel *)rttTitleLabel {
    if (!_rttTitleLabel) {
        _rttTitleLabel = [[UILabel alloc] init];
        _rttTitleLabel.font = [UIFont systemFontOfSize:14];
        _rttTitleLabel.textColor = KWColorFromHexA(0x000000, 0.5);
        _rttTitleLabel.textAlignment = NSTextAlignmentRight;
        _rttTitleLabel.text = @"RTT:";
    }
    return _rttTitleLabel;
}

- (UILabel *)resolutionTitleLabel {
    if (!_resolutionTitleLabel) {
        _resolutionTitleLabel = [[UILabel alloc] init];
        _resolutionTitleLabel.font = [UIFont systemFontOfSize:14];
        _resolutionTitleLabel.textColor = KWColorFromHexA(0x000000, 0.5);
        _resolutionTitleLabel.textAlignment = NSTextAlignmentRight;
        _resolutionTitleLabel.text = @"Resolution:";
    }
    return _resolutionTitleLabel;
}

- (UILabel *)videoTitleLabel {
    if (!_videoTitleLabel) {
        _videoTitleLabel = [[UILabel alloc] init];
        _videoTitleLabel.font = [UIFont systemFontOfSize:14];
        _videoTitleLabel.textColor = KWColorFromHexA(0x000000, 0.5);
        _videoTitleLabel.textAlignment = NSTextAlignmentRight;
        _videoTitleLabel.text = @"Video Send/Rec:";
    }
    return _videoTitleLabel;
}

- (UILabel *)audioTitleLabel {
    if (!_audioTitleLabel) {
        _audioTitleLabel = [[UILabel alloc] init];
        _audioTitleLabel.font = [UIFont systemFontOfSize:14];
        _audioTitleLabel.textColor = KWColorFromHexA(0x000000, 0.5);
        _audioTitleLabel.textAlignment = NSTextAlignmentRight;
        _audioTitleLabel.text = @"Audio Send/Rec:";
    }
    return _audioTitleLabel;
}

- (UILabel *)pktLossTitleLabel {
    if (!_pktLossTitleLabel) {
        _pktLossTitleLabel = [[UILabel alloc] init];
        _pktLossTitleLabel.font = [UIFont systemFontOfSize:14];
        _pktLossTitleLabel.textColor = KWColorFromHexA(0x000000, 0.5);
        _pktLossTitleLabel.textAlignment = NSTextAlignmentRight;
        _pktLossTitleLabel.text = @"Send/Rec Loss:";
    }
    return _pktLossTitleLabel;
}

- (UILabel *)cpuDetailLabel {
    if (!_cpuDetailLabel) {
        _cpuDetailLabel = [[UILabel alloc] init];
        _cpuDetailLabel.font = [UIFont systemFontOfSize:14];
        _cpuDetailLabel.textColor = KWColorFromHex(0x000000);
        _cpuDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cpuDetailLabel;
}

- (UILabel *)memoryDetailLabel {
    if (!_memoryDetailLabel) {
        _memoryDetailLabel = [[UILabel alloc] init];
        _memoryDetailLabel.font = [UIFont systemFontOfSize:14];
        _memoryDetailLabel.textColor = KWColorFromHex(0x000000);
        _memoryDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _memoryDetailLabel;
}

- (UILabel *)rttDetailLabel {
    if (!_rttDetailLabel) {
        _rttDetailLabel = [[UILabel alloc] init];
        _rttDetailLabel.font = [UIFont systemFontOfSize:14];
        _rttDetailLabel.textColor = KWColorFromHex(0x000000);
        _rttDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rttDetailLabel;
}

- (UILabel *)resolutionDetailLabel {
    if (!_resolutionDetailLabel) {
        _resolutionDetailLabel = [[UILabel alloc] init];
        _resolutionDetailLabel.font = [UIFont systemFontOfSize:14];
        _resolutionDetailLabel.textColor = KWColorFromHex(0x000000);
        _resolutionDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _resolutionDetailLabel;
}

- (UILabel *)videoDetailLabel {
    if (!_videoDetailLabel) {
        _videoDetailLabel = [[UILabel alloc] init];
        _videoDetailLabel.font = [UIFont systemFontOfSize:14];
        _videoDetailLabel.textColor = KWColorFromHex(0x000000);
        _videoDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _videoDetailLabel;
}

- (UILabel *)audioDetailLabel {
    if (!_audioDetailLabel) {
        _audioDetailLabel = [[UILabel alloc] init];
        _audioDetailLabel.font = [UIFont systemFontOfSize:14];
        _audioDetailLabel.textColor = KWColorFromHex(0x000000);
        _audioDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _audioDetailLabel;
}

- (UILabel *)pktLossDetailLabel {
    if (!_pktLossDetailLabel) {
        _pktLossDetailLabel = [[UILabel alloc] init];
        _pktLossDetailLabel.font = [UIFont systemFontOfSize:14];
        _pktLossDetailLabel.textColor = KWColorFromHex(0x000000);
        _pktLossDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _pktLossDetailLabel;
}

@end


@implementation KWTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    if (!self.placeholderColor) {
        [super drawPlaceholderInRect:rect];
        return;
    }
    [self.placeholder drawInRect:rect withAttributes:@{NSForegroundColorAttributeName: self.placeholderColor, NSFontAttributeName: self.font}];
}

@end

@interface KWTextInputView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) KWTextField *textField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation KWTextInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.lineView];
    [self addSubview:self.tipsLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(8);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(20);
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self);
        make.height.mas_equalTo(20);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.titleLabel).offset(12);
        make.height.mas_equalTo(1);
    }];

    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(20);
    }];
}

+ (CGFloat)defaultHeight {
    return 61;
}

- (void)updateDefaultUI {
    self.tipsLabel.hidden = YES;
    self.lineView.backgroundColor = KWColorFromHexA(0x000000, 0.1);
}

- (void)updateEditingUI {
    self.tipsLabel.hidden = YES;
    self.lineView.backgroundColor = KWColorFromHex(0x135DFF);
}

- (void)updateAlertUI:(NSString *)alertMsg {
    self.tipsLabel.hidden = NO;
    self.tipsLabel.text = alertMsg;
    self.lineView.backgroundColor = KWColorFromHex(0xFB3C3C);
}

#pragma mark - Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = KWColorFromHex(0x000000);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (KWTextField *)textField {
    if (!_textField) {
        _textField = [[KWTextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textColor = KWColorFromHex(0x000000);
        _textField.tintColor = KWColorFromHex(0x135DFF);
        _textField.placeholderColor = KWColorFromHexA(0x000000, 0.2);
    }
    return _textField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = KWColorFromHexA(0x000000, 0.1);
    }
    return _lineView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        _tipsLabel.textColor = KWColorFromHex(0xFB3C3C);
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tipsLabel;
}

@end


@interface KWAlertView ()

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, copy) dispatch_block_t actionBlock;

@end

@implementation KWAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = KWColorFromHexA(0x000000, 0.4);
    [self addSubview:self.bgButton];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.imageView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.actionButton];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self).offset(-30);
        make.height.mas_equalTo(230);
    }];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(36);
        make.centerX.equalTo(self.containerView);
        make.width.height.mas_equalTo(74);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(21);
    }];

    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(20);
        make.right.equalTo(self.containerView).offset(-20);
        make.bottom.equalTo(self.containerView).offset(-16);
        make.height.mas_equalTo(40);
    }];
}

- (void)updateTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle buttonAction:(dispatch_block_t)actionBlock {
    self.actionBlock = actionBlock;
    self.titleLabel.text = title;
    [self.actionButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)showAnimated:(BOOL)animated {
    self.hidden = NO;
    self.alpha = 0.0f;
    [UIView animateWithDuration:animated ? 0.25f : 0.0f animations:^{
        self.alpha = 1.0f;
    }];
}

- (void)hideAnimated:(BOOL)animated {
    self.alpha = 1.0f;
    [UIView animateWithDuration:animated ? 0.25f : 0.0f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - Action
- (void)onAction:(id)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
    [self hideAnimated:YES];
}

#pragma mark - Getter
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _bgButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.layer.cornerRadius = 8.0f;
        _containerView.layer.masksToBounds = YES;
        _containerView.backgroundColor = KWColorFromHex(0xFFFFFF);
        _containerView.layer.shadowColor = KWColorFromHexA(0x000000, 0.1).CGColor;
        _containerView.layer.shadowOffset = CGSizeMake(0, 16);
        _containerView.layer.shadowRadius = 60;
        _containerView.layer.shadowOpacity = 1;
    }
    return _containerView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = KWImage(@"icon_alert");
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = KWColorFromHexA(0x000000, 0.7);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.layer.cornerRadius = 4.0f;
        _actionButton.layer.masksToBounds = YES;
        [_actionButton setBackgroundColor:KWColorFromHex(0x327DFF)];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_actionButton setTitleColor:KWColorFromHex(0xFFFFFF) forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

@end


@implementation KWPageControl

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    [self reloadCustomView];
}

- (void)reloadCustomView {
    if (@available(iOS 14.0, *)) {
        // UIPageControl::_UIPageControlContentView::_UIPageControlIndicatorContentView::[_UIPageIndicatorView]
        if (!(self.subviews.count > 0 && [NSStringFromClass([self.subviews[0] class]) isEqualToString:@"_UIPageControlContentView"])) {
            return;
        }
        UIView *pageControlContentView = self.subviews[0];
        if (!(pageControlContentView.subviews.count > 0 && [NSStringFromClass([pageControlContentView.subviews[0] class]) isEqualToString:@"_UIPageControlIndicatorContentView"])) {
            return;
        }
        UIView *indicatorContentView = pageControlContentView.subviews[0];
        for (int i = 0; i < indicatorContentView.subviews.count; i++) {
            UIView *indicator = indicatorContentView.subviews[i];
            if (indicator.subviews.count == 0) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [indicator addSubview:imageView];
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(indicator);
                }];
                indicator.backgroundColor = [UIColor clearColor];
                if (i == self.currentPage) {
                    self.currentPageIndicatorTintColor = [UIColor clearColor];
                } else {
                    self.pageIndicatorTintColor = [UIColor clearColor];
                }
            }
            if ([indicator.subviews[0] isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = indicator.subviews[0];
                imageView.image = (i == self.currentPage) ? self.currentPageIndicatorImage : self.pageIndicatorImage;
            }
        }
    } else {
        // UIPageControl::[UIView]
        for (int i = 0; i < self.subviews.count; i++) {
            UIView *indicator = self.subviews[i];
            if (indicator.subviews.count == 0) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [indicator addSubview:imageView];
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(indicator);
                }];
                indicator.backgroundColor = [UIColor clearColor];
                if (i == self.currentPage) {
                    self.currentPageIndicatorTintColor = [UIColor clearColor];
                } else {
                    self.pageIndicatorTintColor = [UIColor clearColor];
                }
            }
            if ([indicator.subviews[0] isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = indicator.subviews[0];
                imageView.image = (i == self.currentPage) ? self.currentPageIndicatorImage : self.pageIndicatorImage;
            }
        }
    }
}

@end
