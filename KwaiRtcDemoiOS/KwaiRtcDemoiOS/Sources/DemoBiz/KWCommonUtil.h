//
//  KWCommonUtil.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/12.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef KWCommonUtil_MACRO
#define KWCommonUtil_MACRO

// COLOR
#define KWColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define KWColorFromHexA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define KWColorRandom [UIColor colorWithRed:(arc4random() % 255)/255.0 green:(arc4random() % 255)/255.0 blue:(arc4random() % 255)/255.0 alpha:1.0]

// FONT
#define KWFontPFRegular(sz) [UIFont fontWithName:@"PingFangSC-Regular" size:sz]
#define KWFontPFMedium(sz) [UIFont fontWithName:@"PingFangSC-Medium" size:sz]

// SCREEN
#define KWScreenMinSide (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
#define KWScreenMaxSide (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
#define KWNavigationBarHeight ([KWCommonUtil isIphoneX] ? 88 : 64)
#define KWTabBarHeight ([KWCommonUtil isIphoneX] ? 83 : 49)

// OTHER
#define KWScaleImage(imageName, szw, szh) [KWCommonUtil scaleImage:[UIImage imageNamed:imageName] size:CGSizeMake(szw, szh)]
#define KWImage(imageName) [UIImage imageNamed:imageName]
#define KWWS __weak typeof(self) weakSelf = self
#define KWSS __strong typeof(weakSelf) self = weakSelf

#endif

NS_ASSUME_NONNULL_BEGIN

@interface KWCommonUtil : NSObject

+ (NSString *)deviceId;

+ (BOOL)isIphoneX;
+ (UIEdgeInsets)iPhoneXLandscapeSafeAreaInsets;
+ (UIEdgeInsets)iPhoneXPortraitSafeAreaInsets;

+ (UIImage *)scaleImage:(UIImage *)source size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
