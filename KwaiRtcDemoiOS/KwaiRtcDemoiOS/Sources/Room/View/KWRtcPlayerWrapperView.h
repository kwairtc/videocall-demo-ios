//
//  KWRtcPlayerWrapperView.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/14.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KWRtcPlayerWrapperViewLayoutLevel) {
    KWRtcPlayerWrapperViewLayoutLevelBig,
    KWRtcPlayerWrapperViewLayoutLevelMiddle,
    KWRtcPlayerWrapperViewLayoutLevelSmall
};

@interface KWRtcPlayerWrapperView : UIView

@property (nonatomic, strong, readonly) UIView *videoCanvasView;
@property (nonatomic, copy) NSString *uid;

- (void)updateName:(NSString *)name;
- (void)updateAvatarName:(NSString *)name;
- (void)updateCanvasAvailable:(BOOL)available;
- (void)updateMicAvailable:(BOOL)available;
- (void)updateLayoutLevel:(KWRtcPlayerWrapperViewLayoutLevel)level;

@end

NS_ASSUME_NONNULL_END
