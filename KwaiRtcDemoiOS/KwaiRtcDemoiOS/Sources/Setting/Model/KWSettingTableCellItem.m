//
//  KWSettingTableCellItem.m
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/28.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import "KWSettingTableCellItem.h"

@implementation KWSettingTableCellItem

+ (instancetype)itemWithType:(KWSettingTableCellItemType)type {
    KWSettingTableCellItem *item = [[KWSettingTableCellItem alloc] init];
    item.type = type;
    return item;
}

- (NSString *)title {
    if (self.type == KWSettingTableCellItemTypeVResolution) {
        return @"清晰度";
    } else if (self.type == KWSettingTableCellItemTypeVBitrate) {
        return @"码率";
    } else if (self.type == KWSettingTableCellItemTypeVFramerate) {
        return @"帧率";
    } else if (self.type == KWSettingTableCellItemTypeASampleRate) {
        return @"采样率";
    } else if (self.type == KWSettingTableCellItemTypeSdkVersion) {
        return @"SDK版本";
    } else if (self.type == KWSettingTableCellItemTypeAppVersion) {
        return @"Demo版本";
    } else if (self.type == KWSettingTableCellItemTypeConsole) {
        return @"通话质量实时数据";
    }
    return @"";
}

@end

@implementation KWSettingTableSectionItem

- (NSMutableArray<KWSettingTableCellItem *> *)cellItems {
    if (!_cellItems) {
        _cellItems = [[NSMutableArray alloc] init];
    }
    return _cellItems;
}

@end
