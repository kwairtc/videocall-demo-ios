//
//  UIView+KWExt.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/20.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KWExt)

- (void)showToast:(NSString *)toast;
- (void)showLoading:(NSString *)text;
- (void)hideHud:(BOOL)animated;

- (BOOL)isVisibleInScreen;

@end

NS_ASSUME_NONNULL_END
