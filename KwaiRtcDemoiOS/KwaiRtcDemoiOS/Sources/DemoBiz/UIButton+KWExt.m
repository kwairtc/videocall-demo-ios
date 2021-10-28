//
//  UIButton+KWExt.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/15.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "UIButton+KWExt.h"
#import <objc/runtime.h>

@implementation UIButton (KWExt)

- (void)setCenterOffsetY:(CGFloat)offsetY {
    objc_setAssociatedObject(self, @selector(centerOffsetY), @(offsetY), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)centerOffsetY {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)alignmentCenterWithSpacing:(CGFloat)spacing {
    CGSize imageSize = self.imageView.bounds.size;
    CGSize titleSize = self.titleLabel.bounds.size;
    CGFloat totalHeight = imageSize.height + titleSize.height + spacing;
    self.imageEdgeInsets = UIEdgeInsetsMake(self.centerOffsetY + imageSize.height - totalHeight, 0, 0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(self.centerOffsetY, -imageSize.width, titleSize.height - totalHeight, 0);
}

@end
