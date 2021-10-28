//
//  KWCommonUtil.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/12.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWCommonUtil.h"

@implementation KWCommonUtil

+ (NSString *)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (BOOL)isIphoneX {
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    if (@available(iOS 11, *)) {
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        if (window.safeAreaInsets.left > 0 || window.safeAreaInsets.bottom > 0) {
            return YES;
        }
    }
    return NO;
}

+ (UIEdgeInsets)iPhoneXLandscapeSafeAreaInsets {
    if ([self isIphoneX]) {
        return UIEdgeInsetsMake(0, 47, 21, 47);
    }
    return UIEdgeInsetsZero;
}

+ (UIEdgeInsets)iPhoneXPortraitSafeAreaInsets {
    if ([self isIphoneX]) {
        return UIEdgeInsetsMake(47, 0, 34, 0);
    }
    return UIEdgeInsetsZero;
}

+ (UIImage *)scaleImage:(UIImage *)source size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [source drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
