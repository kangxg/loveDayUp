//
//  ETTCommandHelperModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/14.
//  Copyright © 2017年 Etiantian. All rights reserved.
//
////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.14 10:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 命令缓存数据表操作
 */
/////////////////////////////////////////////////////
#import "ETTDataHelperModel.h"

@interface ETTCommandHelperModel : ETTDataHelperModel
-(NSString *)selectCommand:(NSString *)uid withkey:(NSString *)key;
@end
