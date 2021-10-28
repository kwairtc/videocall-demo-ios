//
//  KWBaseViewController.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/12.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWBaseViewController.h"

@interface KWBaseViewController ()

@end

@implementation KWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

@end
