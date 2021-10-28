//
//  UIView+KWExt.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/20.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "UIView+KWExt.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIView (KWExt)

- (void)showToast:(NSString *)toast {
    [MBProgressHUD hideHUDForView:self animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.userInteractionEnabled = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = KWColorFromHexA(0x000000, 0.8);
    hud.bezelView.layer.cornerRadius = 4.0;
    hud.bezelView.layer.masksToBounds = YES;
    hud.margin = 16;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabel.font = [UIFont systemFontOfSize:18];
    hud.detailsLabel.textColor = KWColorFromHex(0xFFFFFF);
    hud.detailsLabel.text = toast;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

- (void)showLoading:(NSString *)text {
    [MBProgressHUD hideHUDForView:self animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = KWColorFromHexA(0x000000, 0.8);
    hud.bezelView.layer.cornerRadius = 4.0;
    hud.bezelView.layer.masksToBounds = YES;
    hud.margin = 24;
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = KWImage(@"img_loading");
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.duration = 2.0;
    animation.repeatCount = INFINITY;
    [imageView.layer addAnimation:animation forKey:nil];
    hud.customView = imageView;
    hud.square = YES;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabel.font = [UIFont systemFontOfSize:18];
    hud.detailsLabel.textColor = KWColorFromHex(0xFFFFFF);
    hud.detailsLabel.text = [NSString stringWithFormat:@"\n%@", text];
}

- (void)hideHud:(BOOL)animated {
    [MBProgressHUD hideHUDForView:self animated:animated];
}

- (BOOL)isVisibleInScreen {
    if (!self.superview) {
        return NO;
    }
    if (self.hidden) {
        return NO;
    }
    if (self.alpha == 0.0f) {
        return NO;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect viewRect = [self convertRect:self.frame toView:keyWindow];
    if (CGRectIsEmpty(viewRect) || CGRectIsNull(viewRect) || CGSizeEqualToSize(viewRect.size, CGSizeZero)) {
        return NO;
    }
    CGRect intersectionRect = CGRectIntersection(viewRect, [UIScreen mainScreen].bounds);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect) || CGSizeEqualToSize(intersectionRect.size, CGSizeZero)) {
        return NO;
    }
    return YES;
}

@end
