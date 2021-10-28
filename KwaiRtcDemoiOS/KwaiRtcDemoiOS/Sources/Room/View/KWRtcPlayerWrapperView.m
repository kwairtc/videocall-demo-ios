//
//  KWRtcPlayerWrapperView.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/14.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWRtcPlayerWrapperView.h"

#define AVATAR_SIZE 100

@interface KWRtcPlayerWrapperView ()

@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, strong) UILabel *avatarLabel;
@property (nonatomic, strong) UIView *videoCanvasView;
@property (nonatomic, strong) UIView *nameplateView;
@property (nonatomic, strong) UIImageView *micStatusImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;

@end

@implementation KWRtcPlayerWrapperView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KWColorFromHex(0xF2F2F2);
        [self buildUI];
        [self updateLayoutLevel:KWRtcPlayerWrapperViewLayoutLevelBig];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.avatarView];
    [self.avatarView addSubview:self.avatarLabel];
    [self addSubview:self.videoCanvasView];
    [self addSubview:self.nameplateView];
    [self.nameplateView addSubview:self.micStatusImageView];
    [self.nameplateView addSubview:self.nicknameLabel];

    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(AVATAR_SIZE);
    }];

    [self.avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView).offset(8);
        make.right.equalTo(self.avatarView).offset(-8);
        make.centerY.equalTo(self.avatarView);
    }];

    [self.videoCanvasView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.nameplateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.lessThanOrEqualTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-5);
        make.height.mas_equalTo(22);
    }];

    [self.micStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameplateView);
        make.centerY.equalTo(self.nameplateView);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(22);
    }];

    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.micStatusImageView.mas_right);
        make.centerY.equalTo(self.nameplateView);
        make.height.mas_equalTo(24);
        make.right.equalTo(self.nameplateView).offset(-6).priorityLow();
    }];

    [self.nicknameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateName:(NSString *)name {
    self.nicknameLabel.text = name;
    self.avatarLabel.text = name;
}

- (void)updateAvatarName:(NSString *)name {
    self.avatarLabel.text = name;
}

- (void)updateCanvasAvailable:(BOOL)available {
    self.videoCanvasView.hidden = !available;
    self.avatarView.hidden = available;
}

- (void)updateMicAvailable:(BOOL)available {
    if (available) {
        self.micStatusImageView.image = KWImage(@"icon_mic_on");
    } else {
        self.micStatusImageView.image = KWImage(@"icon_mic_off");
    }
}

- (void)updateLayoutLevel:(KWRtcPlayerWrapperViewLayoutLevel)level {
    if (level == KWRtcPlayerWrapperViewLayoutLevelSmall) {
        [self.avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(AVATAR_SIZE * 0.6);
        }];
        self.avatarView.layer.cornerRadius = AVATAR_SIZE * 0.3;
        self.avatarLabel.font = [UIFont systemFontOfSize:14];
        self.layer.cornerRadius = 5;
    } else if (level == KWRtcPlayerWrapperViewLayoutLevelMiddle) {
        [self.avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(AVATAR_SIZE * 0.8);
        }];
        self.avatarView.layer.cornerRadius = AVATAR_SIZE * 0.4;
        self.avatarLabel.font = [UIFont systemFontOfSize:20];
        self.layer.cornerRadius = 4;
    } else {
        [self.avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(AVATAR_SIZE);
        }];
        self.avatarView.layer.cornerRadius = AVATAR_SIZE * 0.5;
        self.avatarLabel.font = [UIFont systemFontOfSize:24];
        self.layer.cornerRadius = 0;
    }
    self.layer.masksToBounds = YES;
}

#pragma mark - Getter
- (UIView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIView alloc] init];
        _avatarView.backgroundColor = KWColorFromHex(0x327DFF);
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = AVATAR_SIZE * 0.5;
    }
    return _avatarView;
}

- (UILabel *)avatarLabel {
    if (!_avatarLabel) {
        _avatarLabel = [[UILabel alloc] init];
        _avatarLabel.font = [UIFont systemFontOfSize:24];
        _avatarLabel.textColor = KWColorFromHex(0xFFFFFF);
        _avatarLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _avatarLabel;
}

- (UIView *)videoCanvasView {
    if (!_videoCanvasView) {
        _videoCanvasView = [[UIView alloc] init];
    }
    return _videoCanvasView;
}

- (UIView *)nameplateView {
    if (!_nameplateView) {
        _nameplateView = [[UIView alloc] init];
        _nameplateView.backgroundColor = KWColorFromHexA(0xFFFFFF, 0.8);
        _nameplateView.layer.cornerRadius = 3;
        _nameplateView.layer.masksToBounds = YES;
    }
    return _nameplateView;
}

- (UIImageView *)micStatusImageView {
    if (!_micStatusImageView) {
        _micStatusImageView = [[UIImageView alloc] init];
        _micStatusImageView.image = KWImage(@"icon_mic_on");
    }
    return _micStatusImageView;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.font = [UIFont systemFontOfSize:12];
        _nicknameLabel.textColor = KWColorFromHexA(0x000000, 0.65);
        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nicknameLabel;
}

@end
