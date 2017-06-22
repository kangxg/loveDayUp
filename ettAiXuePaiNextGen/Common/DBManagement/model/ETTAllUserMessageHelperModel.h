//
//  ETTAllUserMessageHelperModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/13.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.12 15:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 所有用户信息数据表操作
 */
/////////////////////////////////////////////////////

#import "ETTDataHelperModel.h"

@interface ETTAllUserMessageHelperModel : ETTDataHelperModel


/**
 Description  更新数据

 @param dic  数据
 @param uid  用户ID
 */
-(void)updateTableItem:(NSDictionary *)dic withKey:(NSString *)uid;

/**
 Description  获取用户数据

 @param uid   用户ID
 @return      所有人员字典数据
 */
-(NSDictionary  * )selectAllUserMessage:(NSString *)uid;
@end
