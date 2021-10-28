//
//  KWSettingResolutionTableViewCell.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/28.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWSettingResolutionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *mTitleLabel;
@property (nonatomic, strong) UIView *mSeparatorView;
@property (nonatomic, strong) UIImageView *checkImageView;

+ (CGFloat)defaultHeight;

@end

NS_ASSUME_NONNULL_END
