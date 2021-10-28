//
//  KWRtcPlayerCollectionViewCell.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/14.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWRtcPlayerCollectionViewCell.h"

@interface KWRtcPlayerCollectionViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *seatImageView;
@property (nonatomic, strong) UILabel *seatLabel;

@end

@implementation KWRtcPlayerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.seatImageView];
    [self.contentView addSubview:self.seatLabel];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.seatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-10);
    }];

    [self.seatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seatImageView.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
    }];
}

- (void)clearSubviews {
    for (UIView *view in self.contentView.subviews) {
        if (view != self.bgView && view != self.seatImageView && view != self.seatLabel) {
            [view removeFromSuperview];
        }
    }
    self.bgView.hidden = NO;
}

- (void)loadContent:(UIView *)view {
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.bgView.hidden = YES;
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = KWColorFromHexA(0xFFFFFF, 0.6);
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)seatImageView {
    if (!_seatImageView) {
        _seatImageView = [[UIImageView alloc] init];
        _seatImageView.image = KWImage(@"icon_empty_seat");
    }
    return _seatImageView;
}

- (UILabel *)seatLabel {
    if (!_seatLabel) {
        _seatLabel = [[UILabel alloc] init];
        _seatLabel.font = [UIFont systemFontOfSize:12];
        _seatLabel.textColor = KWColorFromHexA(0x000000, 0.2);
        _seatLabel.textAlignment = NSTextAlignmentCenter;
        _seatLabel.text = @"期待加入";
    }
    return _seatLabel;
}

@end
