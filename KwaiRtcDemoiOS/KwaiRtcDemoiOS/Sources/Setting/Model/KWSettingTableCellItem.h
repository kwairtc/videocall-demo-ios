//
//  KWSettingTableCellItem.h
//  KwaiRtcDemoiOS
//
//  Created by leon on 2021/9/28.
//  Copyright © 2021 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KWSettingTableCellItemType) {
    KWSettingTableCellItemTypeVResolution,
    KWSettingTableCellItemTypeVBitrate,
    KWSettingTableCellItemTypeVFramerate,
    KWSettingTableCellItemTypeASampleRate,
    KWSettingTableCellItemTypeSdkVersion,
    KWSettingTableCellItemTypeAppVersion,
    KWSettingTableCellItemTypeConsole,
};

@interface KWSettingTableCellItem : NSObject

@property (nonatomic, assign) KWSettingTableCellItemType type;

+ (instancetype)itemWithType:(KWSettingTableCellItemType)type;

- (NSString *)title;

@end

@interface KWSettingTableSectionItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray<KWSettingTableCellItem *> *cellItems;

@end


NS_ASSUME_NONNULL_END
