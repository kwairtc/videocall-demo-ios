//
//  KWSettingViewController.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/14.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWSettingViewController.h"
#import "KWSettingTableViewCell.h"
#import "KWSettingTableCellItem.h"
#import "KWSettingResolutionViewController.h"
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
#import <KRtcEngine/KuaishouRtcEngine.h>
#endif
#import "KWRtcSharedDataMgr.h"

NSString *const KWSettingConsoleStatusChangedNotification = @"KWSettingConsoleStatusChangedNotification";
NSString *const KWSettingResolutionChangedNotification = @"KWSettingResolutionChangedNotification";

@interface KWSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *sectionItems;

@property (nonatomic, strong) UIButton *resolutionButton;
@property (nonatomic, strong) UILabel *resolutionLabel;
@property (nonatomic, strong) UIImageView *resolutionArrowImageView;
@property (nonatomic, strong) UILabel *bitrateLabel;
@property (nonatomic, strong) UILabel *frameRateLabel;
@property (nonatomic, strong) UILabel *sampleRateLabel;
@property (nonatomic, strong) UISwitch *consoleSwitch;

@end

@implementation KWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWColorFromHex(0xFFFFFF);
    [self buildData];
    [self buildUI];
    [self updateUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:KWSettingResolutionChangedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)buildData {
    [self.sectionItems removeAllObjects];

    KWSettingTableSectionItem *item0 = [[KWSettingTableSectionItem alloc] init];
    item0.title = @"视频参数";
    KWSettingTableCellItem *item0_0 = [KWSettingTableCellItem itemWithType:KWSettingTableCellItemTypeVResolution];
    KWSettingTableCellItem *item0_1 = [KWSettingTableCellItem itemWithType:KWSettingTableCellItemTypeVBitrate];
    KWSettingTableCellItem *item0_2 = [KWSettingTableCellItem itemWithType:KWSettingTableCellItemTypeVFramerate];
    [item0.cellItems addObjectsFromArray:@[item0_0, item0_1, item0_2]];
    [self.sectionItems addObject:item0];

    KWSettingTableSectionItem *item1 = [[KWSettingTableSectionItem alloc] init];
    item1.title = @"音频参数";
    KWSettingTableCellItem *item1_0 = [KWSettingTableCellItem itemWithType:KWSettingTableCellItemTypeASampleRate];
    [item1.cellItems addObjectsFromArray:@[item1_0]];
    [self.sectionItems addObject:item1];

    KWSettingTableSectionItem *item2 = [[KWSettingTableSectionItem alloc] init];
    item2.title = @"版本";
    KWSettingTableCellItem *item2_0 = [KWSettingTableCellItem itemWithType:KWSettingTableCellItemTypeSdkVersion];
    KWSettingTableCellItem *item2_1 = [KWSettingTableCellItem itemWithType:KWSettingTableCellItemTypeAppVersion];
    KWSettingTableCellItem *item2_2 = [KWSettingTableCellItem itemWithType:KWSettingTableCellItemTypeConsole];
    [item2.cellItems addObjectsFromArray:@[item2_0, item2_1, item2_2]];
    [self.sectionItems addObject:item2];
}

- (void)buildUI {
    [self.view addSubview:self.navigationBarView];
    [self.navigationBarView addSubview:self.titleLabel];
    [self.navigationBarView addSubview:self.backButton];
    [self.view addSubview:self.tableView];

    [self.navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(([KWCommonUtil isIphoneX] ? 44 : 20));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(51);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationBarView);
        make.centerY.equalTo(self.navigationBarView);
        make.height.mas_equalTo(24);
    }];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBarView).offset(8);
        make.centerY.equalTo(self.navigationBarView);
        make.width.height.mas_equalTo(44);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBarView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)updateUI {
    NSNumber *value = [KWRtcSharedDataMgr sharedInstance].currentResolution;
    KWRtcResolutionItem *item;
    if ([value integerValue] == 360) {
        self.resolutionLabel.text = @"流畅 (360P)";
        item = [KWRtcSharedDataMgr resolutionMap][@(360)];
    } else if ([value integerValue] == 540) {
        self.resolutionLabel.text = @"标清 (540P)";
        item = [KWRtcSharedDataMgr resolutionMap][@(540)];
    } else if ([value integerValue] == 720) {
        self.resolutionLabel.text = @"高清 (720P)";
        item = [KWRtcSharedDataMgr resolutionMap][@(720)];
    }
    self.bitrateLabel.text = [NSString stringWithFormat:@"%ld Kbps", (long)item.maxBitrate];
    self.frameRateLabel.text = [NSString stringWithFormat:@"%ld FPS", (long)item.frameRate];
    self.sampleRateLabel.text = [NSString stringWithFormat:@"%ldKHz", (long)([KWRtcSharedDataMgr sampleRate] / 1000)];
}

#pragma mark - Action
- (void)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSelectResolution:(id)sender {
    KWSettingResolutionViewController *vc = [[KWSettingResolutionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onConsole:(UISwitch *)sender {
    BOOL isOpen = [sender isOn];
    [KWRtcSharedDataMgr sharedInstance].enableConsole = isOpen;
    [[NSNotificationCenter defaultCenter] postNotificationName:KWSettingConsoleStatusChangedNotification object:@(isOpen)];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.sectionItems.count) {
        return 0;
    }
    KWSettingTableSectionItem *item = self.sectionItems[section];
    return item.cellItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.sectionItems.count - 1) {
        return 0.00000001;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KWSettingTableViewCell defaultHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"KWSettingHeader"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"KWSettingHeader"];
        view.contentView.backgroundColor = KWColorFromHex(0xFFFFFF);
        UILabel *label = [[UILabel alloc] init];
        label.tag = 66;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = KWColorFromHex(0x000000);
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(20);
            make.centerY.equalTo(view);
        }];

        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = KWColorFromHexA(0x000000, 0.1);
        [view addSubview:separatorView];
        [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(view);
            make.height.mas_equalTo(1);
        }];
    }
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UILabel class]] && subview.tag == 66 && section < self.sectionItems.count) {
            KWSettingTableSectionItem *sectionItem = self.sectionItems[section];
            ((UILabel *)subview).text = sectionItem.title;
            break;
        }
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"KWSettingFooter"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"KWSettingFooter"];
        view.contentView.backgroundColor = KWColorFromHex(0xFFFFFF);
        UIView *darkView = [[UIView alloc] init];
        darkView.backgroundColor = KWColorFromHexA(0x000000, 0.05);
        darkView.tag = 233;
        [view addSubview:darkView];
        [darkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(view);
            make.height.mas_equalTo(0);
        }];
    }
    for (UIView *subview in view.subviews) {
        if (subview.tag == 233) {
            [subview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo((section == self.sectionItems.count - 1) ? 0 : 8);
            }];
            break;
        }
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KWSettingTableViewCell class])];
    if (!cell) {
        cell = [[KWSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([KWSettingTableViewCell class])];
    }
    KWSettingTableSectionItem *sectionItem = self.sectionItems[indexPath.section];
    KWSettingTableCellItem *item = sectionItem.cellItems[indexPath.row];

    // title
    cell.mTitleLabel.text = item.title;

    // detail
    cell.mDetailLabel.text = @"";
    if (item.type == KWSettingTableCellItemTypeSdkVersion) {
#if defined(TARGET_OS_SIMULATOR) && !TARGET_OS_SIMULATOR
        cell.mDetailLabel.text = [KuaishouRtcEngine getSdkVersion];
#endif
    } else if (item.type == KWSettingTableCellItemTypeAppVersion) {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [NSString stringWithFormat:@"%@ (%@)", infoDict[@"CFBundleShortVersionString"], infoDict[@"CFBundleVersion"]];
        cell.mDetailLabel.text = appVersion;
    }

    // ext
    [cell clearExtView];
    if (item.type == KWSettingTableCellItemTypeVResolution) {
        [cell appendExtView:self.resolutionButton completion:^(UIView *view) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.superview).offset(-20);
                make.centerY.equalTo(view.superview);
                make.width.mas_equalTo(160);
                make.height.mas_equalTo(40);
            }];
        }];
    } else if (item.type == KWSettingTableCellItemTypeVBitrate) {
        [cell appendExtView:self.bitrateLabel completion:^(UIView *view) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.superview).offset(-20);
                make.centerY.equalTo(view.superview);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(36);
            }];
        }];
    } else if (item.type == KWSettingTableCellItemTypeVFramerate) {
        [cell appendExtView:self.frameRateLabel completion:^(UIView *view) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.superview).offset(-20);
                make.centerY.equalTo(view.superview);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(36);
            }];
        }];
    } else if (item.type == KWSettingTableCellItemTypeASampleRate) {
        [cell appendExtView:self.sampleRateLabel completion:^(UIView *view) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.superview).offset(-20);
                make.centerY.equalTo(view.superview);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(36);
            }];
        }];
    } else if (item.type == KWSettingTableCellItemTypeConsole) {
        [cell appendExtView:self.consoleSwitch completion:^(UIView *view) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.superview).offset(-14);
                make.centerY.equalTo(view.superview);
            }];
        }];
    }
    return cell;
}

#pragma mark - Getter
- (UIView *)navigationBarView {
    if (!_navigationBarView) {
        _navigationBarView = [[UIView alloc] init];
    }
    return _navigationBarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = KWColorFromHex(0x000000);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"设置";
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:KWImage(@"btn_back") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = KWColorFromHex(0xFFFFFF);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)sectionItems {
    if (!_sectionItems) {
        _sectionItems = [[NSMutableArray alloc] init];
    }
    return _sectionItems;
}

- (UILabel *)resolutionLabel {
    if (!_resolutionLabel) {
        _resolutionLabel = [[UILabel alloc] init];
        _resolutionLabel.font = [UIFont systemFontOfSize:14];
        _resolutionLabel.textColor = KWColorFromHex(0x000000);
        _resolutionLabel.textAlignment = NSTextAlignmentRight;
    }
    return _resolutionLabel;
}

- (UIImageView *)resolutionArrowImageView {
    if (!_resolutionArrowImageView) {
        _resolutionArrowImageView = [[UIImageView alloc] init];
        _resolutionArrowImageView.image = KWImage(@"icon_arrow_gray");
    }
    return _resolutionArrowImageView;
}

- (UIButton *)resolutionButton {
    if (!_resolutionButton) {
        _resolutionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resolutionButton addTarget:self action:@selector(onSelectResolution:) forControlEvents:UIControlEventTouchUpInside];

        [_resolutionButton addSubview:self.resolutionLabel];
        [_resolutionButton addSubview:self.resolutionArrowImageView];
        [self.resolutionArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo(_resolutionButton);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(11);
        }];
        [self.resolutionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.resolutionArrowImageView.mas_left).offset(-6);
            make.centerY.equalTo(self.resolutionArrowImageView);
        }];
    }
    return _resolutionButton;
}

- (UILabel *)bitrateLabel {
    if (!_bitrateLabel) {
        _bitrateLabel = [[UILabel alloc] init];
        _bitrateLabel.font = [UIFont systemFontOfSize:14];
        _bitrateLabel.textColor = KWColorFromHex(0x000000);
        _bitrateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _bitrateLabel;
}

- (UILabel *)frameRateLabel {
    if (!_frameRateLabel) {
        _frameRateLabel = [[UILabel alloc] init];
        _frameRateLabel.font = [UIFont systemFontOfSize:14];
        _frameRateLabel.textColor = KWColorFromHex(0x000000);
        _frameRateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _frameRateLabel;
}

- (UILabel *)sampleRateLabel {
    if (!_sampleRateLabel) {
        _sampleRateLabel = [[UILabel alloc] init];
        _sampleRateLabel.font = [UIFont systemFontOfSize:14];
        _sampleRateLabel.textColor = KWColorFromHex(0x000000);
        _sampleRateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _sampleRateLabel;
}

- (UISwitch *)consoleSwitch {
    if (!_consoleSwitch) {
        _consoleSwitch = [[UISwitch alloc] init];
        _consoleSwitch.onTintColor = KWColorFromHex(0x327DFF);
        _consoleSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [_consoleSwitch addTarget:self action:@selector(onConsole:) forControlEvents:UIControlEventValueChanged];
        BOOL openConsole = [KWRtcSharedDataMgr sharedInstance].enableConsole;
        [_consoleSwitch setOn:openConsole];
    }
    return _consoleSwitch;
}

@end
