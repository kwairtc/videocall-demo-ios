//
//  KWSettingResolutionTableViewCell.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/28.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWSettingResolutionTableViewCell.h"

@implementation KWSettingResolutionTableViewCell

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
    [self.contentView addSubview:self.checkImageView];
    [self.contentView addSubview:self.mSeparatorView];

    [self.mTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
    }];

    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(10);
    }];

    [self.mSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

+ (CGFloat)defaultHeight {
    return 46;
}

#pragma mark - Getter
- (UILabel *)mTitleLabel {
    if (!_mTitleLabel) {
        _mTitleLabel = [[UILabel alloc] init];
        _mTitleLabel.font = [UIFont systemFontOfSize:14];
        _mTitleLabel.textColor = KWColorFromHex(0x000000);
    }
    return _mTitleLabel;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] init];
        _checkImageView.image = KWImage(@"icon_check");
    }
    return _checkImageView;
}

- (UIView *)mSeparatorView {
    if (!_mSeparatorView) {
        _mSeparatorView = [[UIView alloc] init];
        _mSeparatorView.backgroundColor = KWColorFromHexA(0x000000, 0.1);
    }
    return _mSeparatorView;
}


@end
