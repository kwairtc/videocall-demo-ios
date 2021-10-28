//
//  KWSettingTableViewCell.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/28.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWSettingTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *mTitleLabel;
@property (nonatomic, strong) UILabel *mDetailLabel;
@property (nonatomic, strong) UIView *mSeparatorView;
@property (nonatomic, weak) UIView *extView;

+ (CGFloat)defaultHeight;
- (void)clearExtView;
- (void)appendExtView:(UIView *)view completion:(void(^)(UIView *view))completion;

@end

NS_ASSUME_NONNULL_END
