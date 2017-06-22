//
//  ETTDataHelperModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTDataHelpInterface.h"
#import "ETTDataHelperDelegate.h"
#import "ETTDBHeader.h"

////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.12 13:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 数据表操作基类
 */
/////////////////////////////////////////////////////
@interface ETTDataHelperModel : NSObject<ETTDataHelpInterface>


-(void)createTalbel;
-(BOOL)deleteAllDataOfTable;
-(void)deleteAllDataOfTable:(NSString *)uid;
-(NSDictionary *)selectAllData;
-(void)setTableitems:(NSString *)key withValue:(NSString *)value ;
-(id )getTableItems:(NSString *)key;
-(NSString *)dictionaryTransToJsonString:(NSDictionary *)dic;

-(NSDictionary  * )selectMessage:(NSString *)uid;

-(void)updateTableItem:(NSString *)value withKey:(NSString *)key;
-(void)updateTableItem:(NSString *)uid withValue:(NSString *)value withKey:(NSString *)key;



@end
