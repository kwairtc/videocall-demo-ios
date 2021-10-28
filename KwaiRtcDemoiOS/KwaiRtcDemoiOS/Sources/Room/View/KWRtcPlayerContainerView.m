//
//  KWRtcPlayerContainerView.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/12.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWRtcPlayerContainerView.h"
#import "KWRtcPlayerCollectionViewCell.h"

#define COLLECTION_LAYOUT_MARGIN 2.0

@interface KWRtcPlayerContainerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

// pageControl wrapper
@property (nonatomic, strong) UIScrollView *videoContainerView;

// localVideo
@property (nonatomic, strong) KWRtcPlayerWrapperView *localVideoWrapperView;
// remoteVideos
@property (nonatomic, strong) NSMutableArray<KWRtcPlayerWrapperView *> *remoteVideoWrapperArray;

// content wrapper
@property (nonatomic, strong) KWRtcPlayerWrapperView *screenCaptureView;
@property (nonatomic, strong) UICollectionView *videoCollectionView1;
@property (nonatomic, strong) UICollectionView *videoCollectionView2;

@property (nonatomic, assign) BOOL haveScreenCapture;
@property (nonatomic, assign) BOOL swap1on1;
@property (nonatomic, strong) UIButton *swap1on1Button;

@end

@implementation KWRtcPlayerContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.haveScreenCapture = NO;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.videoContainerView];
    [self.videoContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)appendLocalViewWithUid:(NSString *)uid completion:(void(^)(UIView *view))completion {
    if (!uid || uid.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.localVideoWrapperView.uid = uid;
        [self.localVideoWrapperView updateName:uid];
        [self reloadVideoLayout];
        if (completion) {
            completion(self.localVideoWrapperView.videoCanvasView);
        }
    });
}

- (void)appendRemoteViewWithUid:(NSString *)uid completion:(void(^)(UIView *view))completion {
    if (!uid || uid.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        KWRtcPlayerWrapperView *wrapper = [[KWRtcPlayerWrapperView alloc] init];
        wrapper.uid = uid;
        [wrapper updateName:uid];
        [self.remoteVideoWrapperArray addObject:wrapper];
        [self reloadVideoLayout];
        if (completion) {
            completion(wrapper.videoCanvasView);
        }
    });
}

- (void)removeRemoteViewWithUid:(NSString *)uid completion:(void(^)(void))completion {
    if (!uid || uid.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.remoteVideoWrapperArray.count; i++) {
            KWRtcPlayerWrapperView *wrapper = self.remoteVideoWrapperArray[i];
            if ([wrapper.uid isEqualToString:uid]) {
                [self.remoteVideoWrapperArray removeObject:wrapper];
                [self reloadVideoLayout];
                break;
            }
        }
        if (completion) {
            completion();
        }
    });
}

- (void)remoteMuteAudio:(BOOL)mute uid:(NSString *)uid {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (KWRtcPlayerWrapperView *wrapper in self.remoteVideoWrapperArray) {
            if ([wrapper.uid isEqualToString:uid]) {
                [wrapper updateMicAvailable:!mute];
                break;
            }
        }
    });
}

- (void)remoteMuteVideo:(BOOL)mute uid:(NSString *)uid {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (KWRtcPlayerWrapperView *wrapper in self.remoteVideoWrapperArray) {
            if ([wrapper.uid isEqualToString:uid]) {
                [wrapper updateCanvasAvailable:!mute];
                break;
            }
        }
    });
}

- (void)reloadVideoLayout {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL multiScreen = NO;
        // remove all subviews
        [self.swap1on1Button removeFromSuperview];
        for (UIView *view in self.videoContainerView.subviews) {
            [view removeFromSuperview];
        }
        [self.localVideoWrapperView removeFromSuperview];
        for (UIView *view in self.remoteVideoWrapperArray) {
            [view removeFromSuperview];
        }
        self.pageCtrl.numberOfPages = 0;
        self.pageCtrl.currentPage = self.videoContainerView.contentOffset.x / KWScreenMinSide;

        if (self.remoteVideoWrapperArray.count == 0) {
            // only preview
            [self.localVideoWrapperView updateLayoutLevel:KWRtcPlayerWrapperViewLayoutLevelBig];
            [self.videoContainerView addSubview:self.localVideoWrapperView];
            [self.localVideoWrapperView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.videoContainerView);
                make.left.right.equalTo(self.videoContainerView);
                make.width.height.equalTo(self.videoContainerView);
            }];
            self.pageCtrl.numberOfPages += 1;
        } else if (self.remoteVideoWrapperArray.count == 1) {
            // 1 on 1
            if (self.swap1on1) {
                [self.localVideoWrapperView updateLayoutLevel:KWRtcPlayerWrapperViewLayoutLevelBig];
                [self.videoContainerView addSubview:self.localVideoWrapperView];
                [self.localVideoWrapperView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.videoContainerView);
                    make.left.right.equalTo(self.videoContainerView);
                    make.width.height.equalTo(self.videoContainerView);
                }];
                [self.remoteVideoWrapperArray[0] updateLayoutLevel:KWRtcPlayerWrapperViewLayoutLevelSmall];
                [self.videoContainerView addSubview:self.remoteVideoWrapperArray[0]];
                [self.remoteVideoWrapperArray[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.localVideoWrapperView).offset(5);
                    make.right.equalTo(self.localVideoWrapperView).offset(-5);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(ceil(100 * 16.0 / 9.0));
                }];
                [self.videoContainerView addSubview:self.swap1on1Button];
                [self.swap1on1Button mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.remoteVideoWrapperArray[0]);
                }];
            } else {
                [self.remoteVideoWrapperArray[0] updateLayoutLevel:KWRtcPlayerWrapperViewLayoutLevelBig];
                [self.videoContainerView addSubview:self.remoteVideoWrapperArray[0]];
                [self.remoteVideoWrapperArray[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.videoContainerView);
                    make.left.right.equalTo(self.videoContainerView);
                    make.width.height.equalTo(self.videoContainerView);
                }];
                [self.localVideoWrapperView updateLayoutLevel:KWRtcPlayerWrapperViewLayoutLevelSmall];
                [self.videoContainerView addSubview:self.localVideoWrapperView];
                [self.localVideoWrapperView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.remoteVideoWrapperArray[0]).offset(5);
                    make.right.equalTo(self.remoteVideoWrapperArray[0]).offset(-5);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(ceil(100 * 16.0 / 9.0));
                }];
                [self.videoContainerView addSubview:self.swap1on1Button];
                [self.swap1on1Button mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.localVideoWrapperView);
                }];
            }
            self.pageCtrl.numberOfPages += 1;
        } else {
            [self.videoContainerView addSubview:self.videoCollectionView1];
            [self.videoCollectionView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.videoContainerView).offset(COLLECTION_LAYOUT_MARGIN);
                make.bottom.equalTo(self.videoContainerView).offset(-COLLECTION_LAYOUT_MARGIN);
                make.left.equalTo(self.videoContainerView).offset(COLLECTION_LAYOUT_MARGIN);
                make.width.mas_equalTo(KWScreenMinSide - COLLECTION_LAYOUT_MARGIN * 2);
                make.height.mas_equalTo(KWScreenMaxSide - RTC_ROOM_NAVIBAR_HEIGHT - RTC_ROOM_TOOLBAR_HEIGHT - COLLECTION_LAYOUT_MARGIN * 2);
                if (self.remoteVideoWrapperArray.count < 4) {
                    make.right.equalTo(self.videoContainerView).offset(-COLLECTION_LAYOUT_MARGIN);
                }
            }];
            [self.videoCollectionView1 reloadData];
            self.pageCtrl.numberOfPages += 1;
            if (self.remoteVideoWrapperArray.count >= 4) {
                [self.videoContainerView addSubview:self.videoCollectionView2];
                [self.videoCollectionView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.videoContainerView).offset(COLLECTION_LAYOUT_MARGIN);
                    make.bottom.equalTo(self.videoContainerView).offset(-COLLECTION_LAYOUT_MARGIN);
                    make.left.equalTo(self.videoCollectionView1.mas_right).offset(COLLECTION_LAYOUT_MARGIN * 2);
                    make.right.equalTo(self.videoContainerView).offset(-COLLECTION_LAYOUT_MARGIN);
                    make.width.mas_equalTo(KWScreenMinSide - COLLECTION_LAYOUT_MARGIN * 2);
                    make.height.mas_equalTo(KWScreenMaxSide - RTC_ROOM_NAVIBAR_HEIGHT - RTC_ROOM_TOOLBAR_HEIGHT - COLLECTION_LAYOUT_MARGIN * 2);
                }];
                [self.videoCollectionView2 reloadData];
                self.pageCtrl.numberOfPages += 1;
                self.pageCtrl.currentPage = self.videoContainerView.contentOffset.x / KWScreenMinSide;
                multiScreen = YES;
            }
            [self.localVideoWrapperView updateLayoutLevel:KWRtcPlayerWrapperViewLayoutLevelMiddle];
            for (KWRtcPlayerWrapperView *view in self.remoteVideoWrapperArray) {
                [view updateLayoutLevel:KWRtcPlayerWrapperViewLayoutLevelMiddle];
            }
        }
        if ([self.delegate respondsToSelector:@selector(playerContainerDidReloadLayout:)]) {
            [self.delegate playerContainerDidReloadLayout:multiScreen];
        }
    });
}

#pragma mark - Action
- (void)onSwap1on1:(id)sender {
    self.swap1on1 = !self.swap1on1;
    [self reloadVideoLayout];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.pageCtrl.currentPage = self.videoContainerView.contentOffset.x / KWScreenMinSide;
        if ([self.delegate respondsToSelector:@selector(playerContainerDidEndScroll:)]) {
            [self.delegate playerContainerDidEndScroll:decelerate];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageCtrl.currentPage = self.videoContainerView.contentOffset.x / KWScreenMinSide;
    if ([self.delegate respondsToSelector:@selector(playerContainerDidEndScroll:)]) {
        [self.delegate playerContainerDidEndScroll:NO];
    }
}

#pragma mark - UICollectionView Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KWRtcPlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KWRtcPlayerCollectionViewCell class]) forIndexPath:indexPath];
    [cell clearSubviews];
    if (collectionView == self.videoCollectionView1) {
        if (indexPath.item == 0) {
            [cell loadContent:self.localVideoWrapperView];
        } else {
            if (indexPath.item - 1 < self.remoteVideoWrapperArray.count) {
                [cell loadContent:self.remoteVideoWrapperArray[indexPath.item - 1]];
            }
        }
    } else if (collectionView == self.videoCollectionView2) {
        if (indexPath.item + 3 < self.remoteVideoWrapperArray.count) {
            [cell loadContent:self.remoteVideoWrapperArray[indexPath.item + 3]];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KWRtcPlayerCollectionViewCell *cell = (KWRtcPlayerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (![cell isKindOfClass:[KWRtcPlayerCollectionViewCell class]]) {
        return;
    }
}

#pragma mark - Getter
- (UIScrollView *)videoContainerView {
    if (!_videoContainerView) {
        _videoContainerView = [[UIScrollView alloc] init];
        _videoContainerView.pagingEnabled = YES;
        _videoContainerView.showsHorizontalScrollIndicator = NO;
        _videoContainerView.showsVerticalScrollIndicator = NO;
        _videoContainerView.bounces = NO;
        _videoContainerView.delegate = self;
    }
    return _videoContainerView;
}

- (UICollectionView *)videoCollectionView1 {
    if (!_videoCollectionView1) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(floor((KWScreenMinSide - COLLECTION_LAYOUT_MARGIN * 3) / 2.0f), floor((KWScreenMaxSide - RTC_ROOM_NAVIBAR_HEIGHT - RTC_ROOM_TOOLBAR_HEIGHT - COLLECTION_LAYOUT_MARGIN * 3) / 2.0f));
        layout.minimumLineSpacing = COLLECTION_LAYOUT_MARGIN;
        layout.minimumInteritemSpacing = COLLECTION_LAYOUT_MARGIN;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _videoCollectionView1 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _videoCollectionView1.backgroundColor = [UIColor clearColor];
        _videoCollectionView1.delaysContentTouches = NO;
        _videoCollectionView1.delegate = self;
        _videoCollectionView1.dataSource = self;
        [_videoCollectionView1 registerClass:[KWRtcPlayerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([KWRtcPlayerCollectionViewCell class])];
    }
    return _videoCollectionView1;
}

- (UICollectionView *)videoCollectionView2 {
    if (!_videoCollectionView2) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(floor((KWScreenMinSide - COLLECTION_LAYOUT_MARGIN * 3) / 2.0f), floor((KWScreenMaxSide - RTC_ROOM_NAVIBAR_HEIGHT - RTC_ROOM_TOOLBAR_HEIGHT - COLLECTION_LAYOUT_MARGIN * 3) / 2.0f));
        layout.minimumLineSpacing = COLLECTION_LAYOUT_MARGIN;
        layout.minimumInteritemSpacing = COLLECTION_LAYOUT_MARGIN;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _videoCollectionView2 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _videoCollectionView2.backgroundColor = [UIColor clearColor];
        _videoCollectionView2.delaysContentTouches = NO;
        _videoCollectionView2.delegate = self;
        _videoCollectionView2.dataSource = self;
        [_videoCollectionView2 registerClass:[KWRtcPlayerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([KWRtcPlayerCollectionViewCell class])];
    }
    return _videoCollectionView2;
}

- (NSMutableArray *)remoteVideoWrapperArray {
    if (!_remoteVideoWrapperArray) {
        _remoteVideoWrapperArray = [[NSMutableArray alloc] init];
    }
    return _remoteVideoWrapperArray;
}

- (KWRtcPlayerWrapperView *)localVideoWrapperView {
    if (!_localVideoWrapperView) {
        _localVideoWrapperView = [[KWRtcPlayerWrapperView alloc] init];
    }
    return _localVideoWrapperView;
}

- (UIButton *)swap1on1Button {
    if (!_swap1on1Button) {
        _swap1on1Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_swap1on1Button addTarget:self action:@selector(onSwap1on1:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _swap1on1Button;
}

@end
