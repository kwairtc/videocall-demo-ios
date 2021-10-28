//
//  KWRtcDemoUI.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/10/26.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 这里定义的是Demo业务层的一些View，与SDK的接入关系不大，不需要特别关注
 */

NS_ASSUME_NONNULL_BEGIN

#pragma mark - KWRtcRoomNavigationBarView
@class KWRtcRoomNavigationBarView;

@protocol KWRtcRoomNavigationBarViewDelegate <NSObject>

@optional
- (void)navigationBarView:(KWRtcRoomNavigationBarView *)view onAudioRoute:(id)sender;
- (void)navigationBarView:(KWRtcRoomNavigationBarView *)view onSwitchCamera:(id)sender;
- (void)navigationBarView:(KWRtcRoomNavigationBarView *)view onLeaveChannel:(id)sender;
- (void)navigationBarView:(KWRtcRoomNavigationBarView *)view onSelectTitle:(id)sender;

@end

@interface KWRtcRoomNavigationBarView : UIView

@property (nonatomic, weak) id<KWRtcRoomNavigationBarViewDelegate> delegate;

+ (CGFloat)defaultHeight;
- (void)updateChannelId:(NSString *)channelId;
- (void)startTimer;
- (void)stopTimer;

@end

#pragma mark - KWRtcRoomToolbarView
@class KWRtcRoomToolbarView;

@protocol KWRtcRoomToolbarViewDelegate <NSObject>

@optional
- (void)toolBarView:(KWRtcRoomToolbarView *)view onMicphone:(id)sender;
- (void)toolBarView:(KWRtcRoomToolbarView *)view onCamera:(id)sender;
- (void)toolBarView:(KWRtcRoomToolbarView *)view onMemberList:(id)sender;
- (void)toolBarView:(KWRtcRoomToolbarView *)view onBeatuy:(id)sender;
- (void)toolBarView:(KWRtcRoomToolbarView *)view onSetting:(id)sender;

@end

@interface KWRtcRoomToolbarView : UIView

@property (nonatomic, weak) id<KWRtcRoomToolbarViewDelegate> delegate;

+ (CGFloat)defaultHeight;
- (void)updateMicphoneOpenStatus:(BOOL)open;
- (void)updateCameraOpenStatus:(BOOL)open;
- (void)refreshUI;
- (void)updateMemberCount:(NSInteger)count;

@end

#pragma mark - KWRtcRoomInfoView
@protocol KWRtcRoomInfoViewDelegate <NSObject>

@optional
- (void)roomInfoViewDidCopyChannelId:(id)sender;

@end

@interface KWRtcRoomInfoView : UIView

@property (nonatomic, weak) id<KWRtcRoomInfoViewDelegate> delegate;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
- (void)updateChannelId:(NSString *)channelId;

@end


#pragma mark - KWRtcRoomBeautyView
@protocol KWRtcRoomBeautyViewDelegate <NSObject>

@optional
- (void)beautyValueChangedLightening:(NSInteger)lightening smoothness:(NSInteger)smoothness;

@end

@interface KWRtcRoomBeautyView : UIView

@property (nonatomic, weak) id<KWRtcRoomBeautyViewDelegate> delegate;

- (void)showAnimated:(BOOL)animated;
- (void)loadDefaultValue;

@end


#pragma mark - KWRtcRoomMemberView
@interface KWRtcRoomMemberView : UIView

@property (nonatomic, weak) NSArray *userList;

- (void)showAnimated:(BOOL)animated;
- (void)reloadData;

@end


#pragma mark - KWRtcRoomConsoleView
@class KWRtcQosInfo;
@interface KWRtcRoomConsoleView : UIView

+ (CGFloat)defaultWidth;
+ (CGFloat)defaultHeight;
- (void)updateQosInfo:(nullable KWRtcQosInfo *)info;

@end


#pragma mark - KWTextInputView
@interface KWTextField : UITextField

@property (nonatomic, strong) UIColor *placeholderColor;

@end

@interface KWTextInputView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) KWTextField *textField;
@property (nonatomic, strong, readonly) UILabel *tipsLabel;

+ (CGFloat)defaultHeight;

- (void)updateDefaultUI;
- (void)updateEditingUI;
- (void)updateAlertUI:(NSString *)alertMsg;

@end


#pragma mark - KWAlertView
@interface KWAlertView : UIView

- (void)updateTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle buttonAction:(nullable dispatch_block_t)actionBlock;
- (void)showAnimated:(BOOL)animated;

@end


#pragma mark - KWPageControl
@interface KWPageControl : UIPageControl

@property (nonatomic, strong) UIImage *pageIndicatorImage;
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;

@end

NS_ASSUME_NONNULL_END
