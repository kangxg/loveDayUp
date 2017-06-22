//
//  ETTStuChooseRoomHelperModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/13.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.13 11:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 学生选择班级数据表操作
 */
/////////////////////////////////////////////////////
#import "ETTDataHelperModel.h"

@interface ETTStuChooseRoomHelperModel : ETTDataHelperModel
-(void)updateTableItem:(NSDictionary *)dic withKey:(NSString *)uid;
@end
