//
//  ETTDataBaseConfigModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//
////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.12 14:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 数据缓存管理配置类
 */

/////////////////////////////////////////////////////
#import "ETTBaseModel.h"

@interface ETTDataBaseConfigModel : ETTBaseModel
@property (nonatomic,retain,readonly)NSDictionary        * tableNames;
@property (nonatomic,retain,readonly)NSString            * dbName;
@property (nonatomic,retain,readonly)NSString            * clearClassState;
@property (nonatomic,retain,readonly)NSString            * clearIdentity;
@end
