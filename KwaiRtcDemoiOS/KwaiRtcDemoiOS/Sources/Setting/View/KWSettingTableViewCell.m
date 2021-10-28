//
//  KWSettingTableViewCell.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/28.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWSettingTableViewCell.h"

@implementation KWSettingTableViewCell

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
    [self.contentView addSubview:self.mTitleLabel];
    [self.contentView addSubview:self.mDetailLabel];
    [self.contentView addSubview:self.mSeparatorView];

    [self.mTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
    }];

    [self.mDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
    }];

    [self.mSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

+ (CGFloat)defaultHeight {
    return 49;
}

- (void)clearExtView {
    if (self.extView) {
        [self.extView removeFromSuperview];
        self.extView = nil;
    }
}

- (void)appendExtView:(UIView *)view completion:(void(^)(UIView *view))completion {
    self.extView = view;
    [self.contentView addSubview:self.extView];
    if (completion) {
        completion(self.extView);
    }
}

#pragma mark - Getter
- (UILabel *)mTitleLabel {
    if (!_mTitleLabel) {
        _mTitleLabel = [[UILabel alloc] init];
        _mTitleLabel.font = [UIFont systemFontOfSize:14];
        _mTitleLabel.textColor = KWColorFromHexA(0x000000, 0.5);
    }
    return _mTitleLabel;
}

- (UILabel *)mDetailLabel {
    if (!_mDetailLabel) {
        _mDetailLabel = [[UILabel alloc] init];
        _mDetailLabel.font = [UIFont systemFontOfSize:14];
        _mDetailLabel.textColor = KWColorFromHex(0x000000);
    }
    return _mDetailLabel;
}

- (UIView *)mSeparatorView {
    if (!_mSeparatorView) {
        _mSeparatorView = [[UIView alloc] init];
        _mSeparatorView.backgroundColor = KWColorFromHexA(0x000000, 0.1);
    }
    return _mSeparatorView;
}

@end
