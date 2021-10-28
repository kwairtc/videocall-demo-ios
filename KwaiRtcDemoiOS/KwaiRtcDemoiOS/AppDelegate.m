//
//  AppDelegate.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/12.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "AppDelegate.h"
#import "KWLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    NSAssert((KRTC_APP_ID.length > 0 && KRTC_APP_NAME.length > 0 && KRTC_APP_SIGN.length > 0), @"使用KRTC Demo前请先设置 AppId & AppName & AppSign");

    KWLoginViewController *vc = [[KWLoginViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
