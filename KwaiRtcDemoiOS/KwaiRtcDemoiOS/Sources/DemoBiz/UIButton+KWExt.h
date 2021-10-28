//
//  UIButton+KWExt.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/15.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (KWExt)

- (void)setCenterOffsetY:(CGFloat)offsetY;
- (CGFloat)centerOffsetY;
- (void)alignmentCenterWithSpacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
