//
//  ETTGovernmentTask.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/4.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTCoreEnum.h"
#import "ETTBaseTask.h"
@class ETTRestoreCommand;
@interface ETTGovernmentTask : ETTBaseTask



@end


@interface ETTGovernmentWorkTask : ETTGovernmentTask

@end


/**
 Description 课堂操作汇报 任务 主要用于 课堂缓存
 */
@interface ETTGovernmentClassReportTask  :  ETTGovernmentTask
-(instancetype)initTask:(NSInteger)taskType withClassRoom:(NSString *)roomId;
@property (nonatomic,retain,readonly)NSString      * EDDisasterClassRoomid;
@property (nonatomic,retain,readonly)NSString      * EDDisasterType;
@property (nonatomic,retain,readonly)NSDictionary  * EDDisasterDic;
@property (nonatomic,retain,readonly)NSMutableDictionary * EDDisasterOtherDic;
//@property (nonatomic,assign,readonly)ETTBackupOperationState EDDisasterState;

-(void)setOperationState:(ETTBackupOperationState)state;

-(void)setExtensionData:(NSString *)key value:(id)data;
@end



@interface ETTGovRestoreWorkTask : ETTGovernmentTask

@end


