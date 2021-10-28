//
//  KWSettingResolutionViewController.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/28.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWSettingResolutionViewController.h"
#import "KWSettingResolutionTableViewCell.h"
#import "KWRtcSharedDataMgr.h"
#import "KWSettingViewController.h"

@interface KWSettingResolutionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellDatas;

@end

@implementation KWSettingResolutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWColorFromHex(0xFFFFFF);
    [self buildData];
    [self buildUI];
}

- (void)buildData {
    [self.cellDatas addObject:@(360)];
    [self.cellDatas addObject:@(540)];
    [self.cellDatas addObject:@(720)];
}

- (void)buildUI {
    [self.view addSubview:self.navigationBarView];
    [self.navigationBarView addSubview:self.titleLabel];
    [self.navigationBarView addSubview:self.backButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.separatorView];

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

    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tableView.mas_top);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - Action
- (void)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KWSettingResolutionTableViewCell defaultHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWSettingResolutionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KWSettingResolutionTableViewCell class])];
    if (!cell) {
        cell = [[KWSettingResolutionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([KWSettingResolutionTableViewCell class])];
    }
    NSNumber *num = self.cellDatas[indexPath.row];
    NSNumber *curr = [KWRtcSharedDataMgr sharedInstance].currentResolution;
    if ([num integerValue] == 360) {
        cell.mTitleLabel.text = @"流畅 (360P)";
    } else if ([num integerValue] == 540) {
        cell.mTitleLabel.text = @"标清 (540P)";
    } else if ([num integerValue] == 720) {
        cell.mTitleLabel.text = @"高清 (720P)";
    }
    cell.checkImageView.hidden = ([num integerValue] != [curr integerValue]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *num = self.cellDatas[indexPath.row];
    [KWRtcSharedDataMgr sharedInstance].currentResolution = num;
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:KWSettingResolutionChangedNotification object:nil];
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
        _titleLabel.text = @"清晰度";
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

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = KWColorFromHexA(0x000000, 0.1);
    }
    return _separatorView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = KWColorFromHexA(0x000000, 0.05);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)cellDatas {
    if (!_cellDatas) {
        _cellDatas = [[NSMutableArray alloc] init];
    }
    return _cellDatas;
}

@end
