//
//  ETTDataHelpInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.13 10:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 数据表操作类接口
 */
/////////////////////////////////////////////////////
#ifndef ETTDataHelpInterface_h
#define ETTDataHelpInterface_h
#import "ETTDataHelperDelegate.h"
@protocol ETTDataHelpInterface <NSObject>
@optional
@property (nonatomic,weak)id<ETTDataHelperDelegate>  EDDelegate;

/**
 Description 表名
 */
@property (nonatomic,retain,readonly)NSString * EDTableName;

/**
 Description 构造函数

 @param tableName 表名
 @param delegate  代理
 @return  实例
 */
-(instancetype)init:(NSString *)tableName withDelegate:(id<ETTDataHelperDelegate> ) delegate;

@end
#endif /* ETTDataHelpInterface_h */
