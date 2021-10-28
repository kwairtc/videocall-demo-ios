//
//  KWLoginViewController.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/12.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWLoginViewController.h"
#import "KWRtcRoomViewController.h"
#import "KWSettingViewController.h"
#import "KWRtcDemoUI.h"
#import <AVFoundation/AVFoundation.h>

@interface KWLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *helloLabel;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) KWTextInputView *channelIdInput;
@property (nonatomic, strong) KWTextInputView *uidInput;
@property (nonatomic, strong) UIButton *enterRoomButton;
@property (nonatomic, strong) UILabel *cameraLabel;
@property (nonatomic, strong) UILabel *micphoneLabel;
@property (nonatomic, strong) UISwitch *cameraSwitch;
@property (nonatomic, strong) UISwitch *micphoneSwitch;
@property (nonatomic, strong) KWAlertView *alertView;
@property (nonatomic, weak) UITextField *currentFirstResponder;

@end

@implementation KWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWColorFromHex(0xFFFFFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self buildUI];
    [self updateUI];
    [self requestDeviceAuth];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)buildUI {
    [self.view addSubview:self.bgButton];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.helloLabel];
    [self.view addSubview:self.settingButton];
    [self.view addSubview:self.channelIdInput];
    [self.view addSubview:self.uidInput];
    [self.view addSubview:self.enterRoomButton];
    [self.view addSubview:self.cameraLabel];
    [self.view addSubview:self.micphoneLabel];
    [self.view addSubview:self.cameraSwitch];
    [self.view addSubview:self.micphoneSwitch];
    [self.view addSubview:self.alertView];

    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];

    [self.helloLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(59 + KWNavigationBarHeight);
        make.left.equalTo(self.view).offset(36);
    }];

    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KWNavigationBarHeight - 38);
        make.right.equalTo(self.view).offset(-10);
        make.width.height.mas_equalTo(48);
    }];

    [self.channelIdInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(182 + KWNavigationBarHeight);
        make.left.equalTo(self.view).offset(36);
        make.right.equalTo(self.view).offset(-36);
        make.height.mas_equalTo([KWTextInputView defaultHeight]);
    }];

    [self.uidInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.channelIdInput.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(36);
        make.right.equalTo(self.view).offset(-36);
        make.height.mas_equalTo([KWTextInputView defaultHeight]);
    }];

    [self.enterRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uidInput.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(36);
        make.right.equalTo(self.view).offset(-36);
        make.height.mas_equalTo(44);
    }];

    [self.cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enterRoomButton.mas_bottom).offset(44);
        make.left.equalTo(self.view).offset(36);
        make.height.mas_equalTo(24);
    }];

    [self.micphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(36);
        make.height.mas_equalTo(24);
    }];

    [self.cameraSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-32);
        make.centerY.equalTo(self.cameraLabel).offset(-3);
    }];

    [self.micphoneSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-32);
        make.centerY.equalTo(self.micphoneLabel).offset(-3);
    }];

    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)updateUI {
    [self.micphoneSwitch setOn:YES animated:NO];
    [self.cameraSwitch setOn:YES animated:NO];
}

- (void)requestDeviceAuth {
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (!granted) {
                NSLog(@"[LoginVc] init audio NOT granted");
            } else {
                NSLog(@"[LoginVc] init audio granted");
            }
        }];
    }
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {
                NSLog(@"[LoginVc] init video NOT granted");
            } else {
                NSLog(@"[LoginVc] init video granted");
            }
        }];
    }
}

#pragma mark - Action
- (void)onBackground:(id)sender {
    [self.view endEditing:YES];
}

- (void)onSetting:(id)sender {
    NSLog(@"[LoginVc] onSetting");
    KWSettingViewController *vc = [[KWSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onEnterRoom:(id)sender {
    NSLog(@"[LoginVc] onEnterRoom");
    [self.view endEditing:YES];
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioStatus != AVAuthorizationStatusAuthorized) {
        [self.alertView updateTitle:@"请先开启麦克风权限" buttonTitle:@"去开启" buttonAction:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [self.alertView showAnimated:YES];
        NSLog(@"[LoginVc] onEnterRoom while audio auth denied = %ld", (long)audioStatus);
        return;
    }
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoStatus != AVAuthorizationStatusAuthorized) {
        [self.alertView updateTitle:@"请先开启摄像头权限" buttonTitle:@"去开启" buttonAction:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [self.alertView showAnimated:YES];
        NSLog(@"[LoginVc] onEnterRoom while video auth denied = %ld", (long)videoStatus);
        return;
    }
    NSString *channelId = self.channelIdInput.textField.text;
    NSString *userId = self.uidInput.textField.text;
    [self joinChannel:channelId userId:userId];
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.currentFirstResponder) {
        return;
    }
    CGRect textFieldRect = [self.view convertRect:self.currentFirstResponder.frame fromView:self.currentFirstResponder.superview];
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:self.view.window];
    if (keyboardRect.origin.y < textFieldRect.origin.y + textFieldRect.size.height) {
        NSNumber *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration = [animationDurationValue doubleValue];
        CGFloat gap = textFieldRect.origin.y + textFieldRect.size.height - keyboardRect.origin.y;
        KWWS;
        [UIView animateWithDuration:animationDuration animations:^{
            KWSS;
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - gap, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.view.frame.origin.y < 0) {
        NSDictionary *userInfo = [notification userInfo];
        NSNumber *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration = [animationDurationValue doubleValue];
        KWWS;
        [UIView animateWithDuration:animationDuration animations:^{
            KWSS;
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

#pragma mark - Private
- (void)joinChannel:(NSString *)channelId userId:(NSString *)userId {
    KWRtcRoomViewController *vc = [[KWRtcRoomViewController alloc] init];
    KWRtcRoomParam *param = [[KWRtcRoomParam alloc] init];
    param.userId = userId;
    param.channelId = channelId;
    param.micphoneOpen = self.micphoneSwitch.isOn;
    param.cameraOpen = self.cameraSwitch.isOn;
    vc.roomParam = param;
    NSLog(@"[LoginVc] on join channel with ch_id = %@, uid = %@, mic = %ld, cam = %ld", param.channelId, param.userId, (long)param.micphoneOpen, (long)param.cameraOpen);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.channelIdInput.textField) {
        [self.channelIdInput updateEditingUI];
    } else if (textField == self.uidInput.textField) {
        [self.uidInput updateEditingUI];
    }
    self.currentFirstResponder = textField;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.channelIdInput.textField) {
        if (textField.text.length == 0) {
            [self.channelIdInput updateAlertUI:@"请输入房间ID"];
        } else {
            [self.channelIdInput updateDefaultUI];
        }
    } else if (textField == self.uidInput.textField) {
        if (textField.text.length == 0) {
            [self.uidInput updateAlertUI:@"请输入用户ID"];
        } else {
            [self.uidInput updateDefaultUI];
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    UITextRange *selectedRange = textField.markedTextRange;
    if (selectedRange == nil || selectedRange.empty) {
        if (textField == self.channelIdInput.textField ||
            textField == self.uidInput.textField) {
            // only keep 0-9
            NSString *sourceString = textField.text;
            NSString *trimString = [[sourceString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
            if (sourceString.length != trimString.length) {
                textField.text = trimString;
            }
            if (textField.text.length > 24) {
                textField.text = [textField.text substringToIndex:24];
            }
        }
        if (self.channelIdInput.textField.text.length > 0 && self.channelIdInput.textField.text.length <= 24 &&
            self.uidInput.textField.text.length > 0 && self.uidInput.textField.text.length <= 24) {
            self.enterRoomButton.enabled = YES;
        } else {
            self.enterRoomButton.enabled = NO;
        }
   }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

#pragma mark - Getter
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton addTarget:self action:@selector(onBackground:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.image = KWImage(@"img_login_bg");
    }
    return _bgImageView;
}

- (UILabel *)helloLabel {
    if (!_helloLabel) {
        _helloLabel = [[UILabel alloc] init];
        _helloLabel.numberOfLines = 0;
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.lineSpacing = 16;
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"你好，\n欢迎使用 Kwai RTC" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName: KWColorFromHex(0x000000), NSParagraphStyleAttributeName: pStyle}];

        _helloLabel.attributedText = attr;

    }
    return _helloLabel;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:KWImage(@"btn_setting_line") forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (KWTextInputView *)channelIdInput {
    if (!_channelIdInput) {
        _channelIdInput = [[KWTextInputView alloc] init];
        _channelIdInput.titleLabel.text = @"房间ID";
        _channelIdInput.textField.placeholder = @"输入房间ID";
        _channelIdInput.textField.keyboardType = UIKeyboardTypeNumberPad;
        _channelIdInput.textField.delegate = self;
        [_channelIdInput.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_channelIdInput updateDefaultUI];
    }
    return _channelIdInput;
}

- (KWTextInputView *)uidInput {
    if (!_uidInput) {
        _uidInput = [[KWTextInputView alloc] init];
        _uidInput.titleLabel.text = @"用户ID";
        _uidInput.textField.placeholder = @"输入用户ID";
        _uidInput.textField.keyboardType = UIKeyboardTypeNumberPad;
        _uidInput.textField.delegate = self;
        [_uidInput.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_uidInput updateDefaultUI];
    }
    return _uidInput;
}

- (UIButton *)enterRoomButton {
    if (!_enterRoomButton) {
        _enterRoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterRoomButton.layer.cornerRadius = 4.0f;
        _enterRoomButton.layer.masksToBounds = YES;
        [_enterRoomButton setBackgroundImage:[KWCommonUtil imageWithColor:KWColorFromHex(0x327DFF)] forState:UIControlStateNormal];
        [_enterRoomButton setBackgroundImage:[KWCommonUtil imageWithColor:KWColorFromHexA(0x327DFF, 0.2)] forState:UIControlStateDisabled];
        _enterRoomButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_enterRoomButton setTitleColor:KWColorFromHex(0xFFFFFF) forState:UIControlStateNormal];
        [_enterRoomButton setTitle:@"进入房间" forState:UIControlStateNormal];
        _enterRoomButton.enabled = NO;
        [_enterRoomButton addTarget:self action:@selector(onEnterRoom:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterRoomButton;
}

- (UILabel *)cameraLabel {
    if (!_cameraLabel) {
        _cameraLabel = [[UILabel alloc] init];
        _cameraLabel.font = [UIFont systemFontOfSize:14];
        _cameraLabel.textColor = KWColorFromHex(0x000000);
        _cameraLabel.text = @"打开摄像头";
    }
    return _cameraLabel;
}

- (UILabel *)micphoneLabel {
    if (!_micphoneLabel) {
        _micphoneLabel = [[UILabel alloc] init];
        _micphoneLabel.font = [UIFont systemFontOfSize:14];
        _micphoneLabel.textColor = KWColorFromHex(0x000000);
        _micphoneLabel.text = @"打开麦克风";
    }
    return _micphoneLabel;
}

- (UISwitch *)cameraSwitch {
    if (!_cameraSwitch) {
        _cameraSwitch = [[UISwitch alloc] init];
        _cameraSwitch.onTintColor = KWColorFromHex(0x327DFF);
        _cameraSwitch.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }
    return _cameraSwitch;
}

- (UISwitch *)micphoneSwitch {
    if (!_micphoneSwitch) {
        _micphoneSwitch = [[UISwitch alloc] init];
        _micphoneSwitch.onTintColor = KWColorFromHex(0x327DFF);
        _micphoneSwitch.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }
    return _micphoneSwitch;
}

- (KWAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[KWAlertView alloc] init];
        _alertView.hidden = YES;
    }
    return _alertView;
}

@end
