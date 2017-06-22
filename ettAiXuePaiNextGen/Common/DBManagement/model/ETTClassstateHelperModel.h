//
//  ETTClassstateHelperModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/12.
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
 describe : 课堂状态信息数据表操作
 */
/////////////////////////////////////////////////////

#import "ETTDataHelperModel.h"
#import "ETTDataBaseConfigModel.h"
@interface ETTClassstateHelperModel : ETTDataHelperModel



/**
 Description  获取用户状态信息

 @param uid 用户ID
 @return json 格式字符串
 */
-(NSString * )selectClassState:(NSString *)uid;
/**
 Description  删除用户状态信息
 
 @param uid 用户ID

 */
-(void)deleteClassState:(NSString *)uid;
@end
